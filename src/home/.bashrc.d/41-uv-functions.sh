#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/uv-functions.sh
# Funções do UV
# ==========================================================================================

#-------------------------------------------------------------------------------------------
# Função para exibir informações do UV
#-------------------------------------------------------------------------------------------
uv-info() {
    echo "=== Informações do UV ==="
    echo "APPS_BASE .............: $APPS_BASE"
    echo "UV instalado ..........: $(uv --version)"
    echo "Diretório do binário ..: $UV_INSTALL_DIR"
    echo "Diretório de cache.....: $UV_CACHE_DIR"
    echo "Diretório de tools.....: $UV_TOOL_DIR"
    echo "Arquivo de configuração: $UV_CONFIG_FILE"
    echo "Python install dir ....: $UV_PYTHON_INSTALL_DIR"
    echo ""
    echo "=== Configurações atuais ==="
    echo "  UV_COMPILE_BYTECODE....: $UV_COMPILE_BYTECODE"
    echo "  UV_LINK_MODE...........: $UV_LINK_MODE"
    echo "  UV_PYTHON_PREFERENCE...: $UV_PYTHON_PREFERENCE"
    echo ""
    echo "=== Versões de Python gerenciadas pelo UV ==="
    uv python list 2>/dev/null || echo "Nenhuma versão de Python instalada ainda"
}


#-------------------------------------------------------------------------------------------
# Função para limpar cache do UV
#-------------------------------------------------------------------------------------------
uv-clean() {
    echo "Limpando cache do UV..."
    uv cache clean
    echo "Cache limpo!"
}


#-------------------------------------------------------------------------------------------
# Função para inicializar projeto Python com UV
#-------------------------------------------------------------------------------------------
uv-new-project() {
    local python_version=${1:-"3.12"}
    local project_name=${2:-"my-project"}
    
    echo "Criando projeto Python: $project_name"
    echo "Python version: $python_version"
    
    # Criar diretório do projeto
    mkdir -p "$project_name"
    cd "$project_name"
    
    # Inicializar projeto UV
    uv init --python "$python_version"
    
    # Instalar dependências de desenvolvimento básicas
    uv add --dev pytest pytest-cov black isort mypy ruff
    
    echo "Projeto $project_name criado com sucesso!"
    echo "Para ativar: cd $project_name && uv shell"
}


#-------------------------------------------------------------------------------------------
# Função para navegar para projetos
#-------------------------------------------------------------------------------------------
uv-goto-project() {
    local project_name="$1"
    if [ -z "$project_name" ]; then
        echo "Projetos disponíveis:"
        ls -1 "$APPS_BASE/projects/" 2>/dev/null || echo "Nenhum projeto encontrado"
        return 1
    fi
    
    if [ -d "$APPS_BASE/projects/$project_name" ]; then
        cd "$APPS_BASE/projects/$project_name"
        echo "Navegando para: $project_name"
        # Ativar ambiente virtual se existir
        if [ -f ".venv/bin/activate" ]; then
            source .venv/bin/activate
            echo "Ambiente virtual ativado"
        fi
    else
        echo "Projeto '$project_name' não encontrado em $APPS_BASE/projects/"
    fi
}

#-------------------------------------------------------------------------------------------
#--- Final do script 'uv-functions.sh'
#-------------------------------------------------------------------------------------------