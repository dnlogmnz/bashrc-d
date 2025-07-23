#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/python-functions.sh
# Funções para facilitar o uso do Python gerenciado pelo UV
# ==========================================================================================

# Diretório para symlinks do Python (deve estar no PATH)
PYTHON_SYMLINKS_DIR="$APPS_BASE/python/bin"

# Adicionar diretório de symlinks do Python ao PATH
mkdir -p "$PYTHON_SYMLINKS_DIR"
[[ ":$PATH:" != *":${PYTHON_SYMLINKS_DIR}:"* ]] && export PATH="${PYTHON_SYMLINKS_DIR}:$PATH"


#-------------------------------------------------------------------------------------------
# Função para criar symlinks dinâmicos do Python
#-------------------------------------------------------------------------------------------
py-create-symlinks() {
    local python_version=$(py-get-default)
    local python_path=$(uv-get-python-path "$python_version")

    # Criar diretório para symlinks se não existir
    mkdir -p "$PYTHON_SYMLINKS_DIR"

    if [ -n "$python_path" ] && [ -f "$python_path" ]; then
        echo "Criando symlinks para Python $python_version"

        # Remover symlinks antigos
        rm -f "$PYTHON_SYMLINKS_DIR/python"
        rm -f "$PYTHON_SYMLINKS_DIR/python3"
        rm -f "$PYTHON_SYMLINKS_DIR/pip"
        rm -f "$PYTHON_SYMLINKS_DIR/pip3"

        # Criar novos symlinks
        ln -sf "$python_path" "$PYTHON_SYMLINKS_DIR/python"
        ln -sf "$python_path" "$PYTHON_SYMLINKS_DIR/python3"

        # Criar symlink para pip (encontrar pip no mesmo diretório do python)
        local pip_path="${python_path%/*}/Scripts/pip.exe"
        if [ -f "$pip_path" ]; then
            ln -sf "$pip_path" "$PYTHON_SYMLINKS_DIR/pip"
            ln -sf "$pip_path" "$PYTHON_SYMLINKS_DIR/pip3"
        fi

        echo "Symlinks criados em: $PYTHON_SYMLINKS_DIR"
    else
        echo "Python não encontrado: $python_path"
        return 1
    fi
}


#-------------------------------------------------------------------------------------------
# Função para sincronizar com .python-version local
#-------------------------------------------------------------------------------------------
py-sync-from-file() {
    if [ -f ".python-version" ]; then
        local version=$(cat .python-version)
        echo "Versão encontrada no .python-version: $version"
        
        # Verificar se está instalada
        if ! uv python list --only-installed | grep -q "$version"; then
            echo "Instalando Python $version..."
            uv python install "$version"
        fi
        
        # Atualizar symlinks se necessário
        py-create-symlinks
    else
        echo "Nenhum arquivo .python-version encontrado no diretório atual"
    fi
}


#-------------------------------------------------------------------------------------------
# Função para obter versão Python padrão
#-------------------------------------------------------------------------------------------
py-get-default() {
    if [ -f "$APPS_BASE/python/.default_version" ]; then
        cat "$APPS_BASE/python/.default_version"
    else
        # Fallback para primeira versão gerenciada pelo UV que encontrar
        local first_version=$(ls -d $APPS_BASE/python/*$version*/python.exe 2>/dev/null)
        echo "${first_version:-3.12}"
    fi
}


#-------------------------------------------------------------------------------------------
# Função para definir versão Python padrão
#-------------------------------------------------------------------------------------------
py-set-default() {
    local version="$1"
    if [ -z "$version" ]; then
        echo "Uso: py-set-default <versão>"
        echo "Versões disponíveis:"
        uv python list --only-installed
        return 1
    fi

    # Verificar se a versão está instalada
    if ! uv python list --only-installed | grep -q "$version"; then
        echo "Versão $version não está instalada. Instalando..."
        uv python install "$version"
    fi

    # Salvar versão padrão
    mkdir -p "$APPS_BASE/python"
    echo "$version" > "$APPS_BASE/python/.default_version"

    # Recriar symlinks
    py-create-symlinks

    echo "Versão padrão definida para: $version"
}


#-------------------------------------------------------------------------------------------
# Função para obter caminho do Python gerenciado pelo UV
#-------------------------------------------------------------------------------------------
uv-get-python-path() {
    local version="$1"
    [ -z "$version" ] && version=$(py-get-default)

    # Tentar obter o caminho do Python via UV
    local python_path=$(uv python find "$version" 2>/dev/null)
    if [ -n "$python_path" ] && [ -f "$python_path" ]; then
        echo "$python_path"
    else
        # Fallback: procurar no diretório de instalação do UV
        ls -d $APPS_BASE/python/*$version*/python.exe 2>/dev/null || echo "Não encontrado" | head -1
    fi
}


#-------------------------------------------------------------------------------------------
# Função para mostrar versão Python atual
#-------------------------------------------------------------------------------------------
py-info() {
    echo "=== Informações do Python ==="

    # Informações do projeto atual
    local context="Global"
    local python_version="$(py-get-default)"
    local python_project_dir="$( [ ! -z "${VIRTUAL_ENV}" ] && dirname ${VIRTUAL_ENV} || echo $PWD )"
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
    echo "   Contexto ..............: $context "
    echo "   Versão global padrão ..: $(py-get-default)"
    echo "   Versão corrente .......: $python_version"

    # Mostrar caminho do Python UV se disponível
    local uv_python_path=$(uv-get-python-path)
    [ -n "$uv_python_path" ] && echo "   Executável do Python ..: $uv_python_path"

    # Mostrar python no PATH se existir
    local python_path=$(which python 2>/dev/null)
    echo "   Python no PATH ........: ${python_path:-executável python não encontrado no PATH}"
    echo "   Symlinks dir ..........: $PYTHON_SYMLINKS_DIR"
    echo "   Pip ...................: $(`which pip 2>/dev/null` --version 2>/dev/null || echo 'pip não encontrado')"
    echo ""
    echo "=== Versões de Python instaladas pelo UV ==="
    uv python list --only-installed 2>/dev/null || echo "UV não encontrado"
    echo ""
}


#-------------------------------------------------------------------------------------------
# Função que implementa o alias python
#-------------------------------------------------------------------------------------------
_python_uv() {
    local python_version=$(py-get-default)
    # Verificar se estamos em um projeto UV (tem pyproject.toml)
    if [ -f "pyproject.toml" ] && grep -q "tool.uv" "pyproject.toml" 2>/dev/null; then
        # Dentro de projeto UV: usar uv run python
        uv run python "$@"
    elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
        # Dentro de projeto Python genérico: usar uv run python
        uv run python "$@"
    elif [ -n "$VIRTUAL_ENV" ]; then
        # Dentro de venv ativo: usar python do venv
        command python "$@"
    elif [ -n "$python_version" ]; then
    # Fora de projeto: usar python gerenciado pelo UV
        uv run --python "$python_version" python "$@"
    else
        echo "Nenhum Python instalado pelo UV. Use: uv python install 3.12"
        return 1
    fi
}


#-------------------------------------------------------------------------------------------
# Função que implementa o alias pip
#-------------------------------------------------------------------------------------------
_pip_uv() {
    # Verificar se estamos em um projeto UV
    if [ -f "pyproject.toml" ] && grep -q "tool.uv" "pyproject.toml" 2>/dev/null; then
        # Dentro de projeto UV: usar uv add/remove
        echo "Use 'uv add <package>' ou 'uv remove <package>' em projetos UV"
        echo "Para instalar globalmente: uv tool install <package>"
        return 1
    elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
        # Dentro de projeto Python genérico: usar uv pip
        uv pip "$@"
    elif [ -n "$VIRTUAL_ENV" ]; then
        # Dentro de venv ativo: usar pip do venv
        command pip "$@"
    else
        # Ambiente global, fora de projeto: sugerir uv tool install
        echo "Fora de projeto, use:"
        echo "  uv tool install <package>  # Para instalar ferramenta global"
        echo "  uv pip install <package>   # Para instalar em ambiente específico"
        return 1
    fi
}


#-------------------------------------------------------------------------------------------
# Aliases para facilitar o uso do Python
#-------------------------------------------------------------------------------------------
alias python='_python_uv'
alias pip='_pip_uv'

# Criar symlinks silenciosamente quando o script é carregado
py-create-symlinks 1>/dev/null 2>&1 || :

#-------------------------------------------------------------------------------------------
#--- Final do script 'python-functions.sh'
#-------------------------------------------------------------------------------------------