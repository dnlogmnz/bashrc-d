#!/bin/bash
# =============================================================================
# Arquivo: python-envs.sh
# Variaveis de ambiente para o Python (gerenciado pelo UV)
# =============================================================================

# Configurações do Python
export PYTHONIOENCODING="utf-8"
export PYTHONDONTWRITEBYTECODE="1" # Não gerar arquivos .pyc (melhora performance em containers/CI)
export PYTHONUNBUFFERED="1" # Saída não bufferizada (importante para logs em tempo real)
export PYTHON_HISTORY="$APPS_BASE/python/.python_history" # Histórico do Python REPL (persiste comandos entre sessões)

# Configurações do pip (caso seja usado diretamente)
export PIP_REQUIRE_VIRTUALENV="true"  # Sempre usar ambiente virtual
export PIP_DISABLE_PIP_VERSION_CHECK="1"  # Não verificar atualizações do pip

# =============================================================================
# Funções de gerenciamento de versões Python
# =============================================================================

#--------------------------------------------------------------------------------
# Função para obter versão Python padrão
#--------------------------------------------------------------------------------
get-default-python() {
    if [ -f "$APPS_BASE/python/.default_version" ]; then
        cat "$APPS_BASE/python/.default_version"
    else
        # Fallback para primeira versão gerenciada pelo UV que encontrar
        ls -d $APPS_BASE/python/*$version*/python.exe 2>/dev/null || echo "Não encontrado" | head -1
    fi
}

#--------------------------------------------------------------------------------
# Função para obter caminho do Python gerenciado pelo UV
#--------------------------------------------------------------------------------
get-uv-python-path() {
    local version="$1"
    [ -z "$version" ] && version=$(get-default-python)
    
    # Tentar obter o caminho do Python via UV
    local python_path=$(uv python find "$version" 2>/dev/null)
    if [ -n "$python_path" ] && [ -f "$python_path" ]; then
        echo "$python_path"
    else
        # Fallback: procurar no diretório de instalação do UV
        ls -d $APPS_BASE/python/*$version*/python.exe 2>/dev/null || echo "Não encontrado" | head -1
    fi
}

#--------------------------------------------------------------------------------
# Função para mostrar versão Python atual
#--------------------------------------------------------------------------------
show-python-info() {
    echo "=== Informações do Python ==="
    
    # Posicionando o script: diretório base de um projeto, ou diretório corrente
    local context="Global"
    local python_version="$(get-default-python)"
    local python_project_dir="$( [ ! -z "${VIRTUAL_ENV}" ] && dirname ${VIRTUAL_ENV} || echo $PWD )"

    # Informações do projeto atual
    pushd $python_project_dir 1>/dev/null
    if [ -f "pyproject.toml" ] && grep -q "tool.uv" "pyproject.toml" 2>/dev/null; then
        # Dentro de projeto Python com UV
        context="$(echo -n "${VIRTUAL_ENV_PROMPT}${VIRTUAL_ENV_PROMPT:+: }"; echo "projeto Python com uv")"
        python_version=$(uv run python --version 2>/dev/null)
    elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
        # Dentro de projeto Python genérico
        context="$(echo -n "${VIRTUAL_ENV_PROMPT}${VIRTUAL_ENV_PROMPT:+: }"; echo "projeto Python genérico")"
        python_version=$(uv run python --version 2>/dev/null)
    elif [ -n "$VIRTUAL_ENV" ]; then
        # Dentro de venv ativo
        context="Virtual env (${VIRTUAL_ENV_PROMPT})"
        python_version=$(python --version 2>/dev/null)
    elif [ -n "$python_version" ]; then
        # Não identificou projeto: validar se usa python gerenciado pelo UV
        context="Sistema/UV global"
        python_version=$(uv run --python "$python_version" python --version 2>/dev/null)
    else
        context="Nenhum Python configurado"
        python_version="Não disponível"
    fi
    popd 1>/dev/null
    echo "Contexto ..............: $context "
    echo "Versão global padrão ..: $(get-default-python)"
    echo "Versão corrente .......: $python_version"

    # Mostrar caminho do Python UV se disponível
    local uv_python_path=$(get-uv-python-path)
    [ -n "$uv_python_path" ] && echo "Executável ............: $uv_python_path"

    # Mostrar python no PATH se existir
    local path_python=$(which python 2>/dev/null)
    echo "Python no PATH ........: ${path_python:-executável do Python não está no PATH}"
    echo "Pip ...................: $(`which pip 2>/dev/null` --version 2>/dev/null || echo 'pip não encontrado')"

    echo ""
    echo "=== Versões de Python instaladas pelo UV ==="
    uv python list --only-installed 2>/dev/null || echo "UV não encontrado"
    echo ""
    
}

#--------------------------------------------------------------------------------
#--- Final do script
#--------------------------------------------------------------------------------