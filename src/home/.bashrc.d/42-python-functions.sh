#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/python-functions.sh
# Funções de gerenciamento de versões Python
# Aliases Python inteligentes usando UV
# ==========================================================================================

#-------------------------------------------------------------------------------------------
# Função para obter versão Python padrão
#-------------------------------------------------------------------------------------------
py-get-default() {
    if [ -f "$APPS_BASE/python/.default_version" ]; then
        cat "$APPS_BASE/python/.default_version"
    else
        # Fallback para primeira versão gerenciada pelo UV que encontrar
        echo $(ls -d $APPS_BASE/python/*$version*/python.exe 2>/dev/null) || echo "Não encontrado" | head -1
    fi
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
    echo "Contexto ..............: $context "
    echo "Versão global padrão ..: $(py-get-default)"
    echo "Versão corrente .......: $python_version"

    # Mostrar caminho do Python UV se disponível
    local uv_python_path=$(uv-get-python-path)
    [ -n "$uv_python_path" ] && echo "Executável ............: $uv_python_path"

    # Mostrar python no PATH se existir
    local python_path=$(which python 2>/dev/null)
    echo "Python no PATH ........: ${python_path:-executável do Python não está no PATH}"
    echo "Pip ...................: $(`which pip 2>/dev/null` --version 2>/dev/null || echo 'pip não encontrado')"

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

#-------------------------------------------------------------------------------------------
#--- Final do script 'python-functions.sh'
#-------------------------------------------------------------------------------------------