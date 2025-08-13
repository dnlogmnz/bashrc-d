#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/python-functions.sh
# Funções para facilitar o uso do Python gerenciado pelo UV
# ==========================================================================================

#-------------------------------------------------------------------------------------------
# Função para mostrar versão Python atual
#-------------------------------------------------------------------------------------------
py-info() {
    local context="Global"
    local python_version="$(py-get-default)"
    local python_project_dir="$( [ ! -z "${VIRTUAL_ENV}" ] && dirname ${VIRTUAL_ENV} || echo $PWD )"

    # Contexto do projeto atual
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

    echo "=== Informações da versão padrão do Python no sistema ==="
    echo "  Diretório PYTHON_BASE .: $PYTHON_BASE"
    [ -L "$PYTHON_BASE/current" ] && echo "  Symlink versão padrão .: $PYTHON_BASE/current"
    [ -L "$PYTHON_BASE/current" ] && echo "  Symlink aponta para ...: $(readlink "$PYTHON_BASE/current" 2>/dev/null)"
    echo "  Diretório com os shims : ${PYTHON_SHIMS_DIR:-not set}"
    echo "  Versão padrão .........: $(py-get-default)"

    echo ""
    echo "=== Informações da versão corrente do Python ==="
    echo "  Contexto corrente .....: $context "
    echo "  Versão corrente .......: $python_version"

    # Mostrar caminho do Python UV se disponível
    local uv_python_path=$(_uv-get-python-path)
    local python_path=$(which python 2>/dev/null)
    [ -n "$uv_python_path" ]      && echo "  Executável corrente ...: $uv_python_path"
    echo "  Executável no PATH ....: ${python_path:-executável python não encontrado no PATH}"
    echo "  Pip ...................: $(`which pip 2>/dev/null` --version 2>/dev/null || echo 'pip não encontrado')"
    echo ""
}


#-------------------------------------------------------------------------------------------
# Função para listar todas as versões Python disponíveis
#-------------------------------------------------------------------------------------------
py-versions() {
    echo "=== Versões Python Disponíveis ==="
    
    echo ""
    echo "--- Versão corrente ---"
    if [ -d "$PYTHON_BASE/current" ]; then
        current_target=$(readlink "$PYTHON_BASE/current" 2>/dev/null || echo "Junction para: $PYTHON_BASE/current")
        current_version=$("$PYTHON_BASE/current/python.exe" --version 2>/dev/null || echo "Erro ao obter versão")
        echo "$current_version em '$current_target'"
    else
        echo "Nenhuma versão definida como corrente"
    fi

    # Versões instaladas manualmente
    echo ""
    echo "--- Versões instaladas manualmente ---"
    if [ -d "$PYTHON_BASE" ]; then
        for dir in $(/bin/ls -d $PYTHON_BASE/{P,p,cp}ython* 2>/dev/null); do
            if [ -d "$dir" ] && [ -f "$dir/python.exe" ]; then
                version=$("$dir/python.exe" --version 2>/dev/null || echo "Versão desconhecida")
                echo "$version em '$dir'"
            fi
        done
    else
        echo "Diretório $PYTHON_BASE não encontrado"
    fi
    
    # Versões gerenciadas pelo UV
    if command -v uv &>/dev/null; then
        echo ""
        echo "--- Versões gerenciadas pelo UV ---"
        uv python list --managed-python 2>/dev/null || echo "Nenhuma versão UV encontrada"
        echo ""
    fi
}


#-------------------------------------------------------------------------------------------
# Função para obter versão Python padrão
#-------------------------------------------------------------------------------------------
py-get-default() {
    if [ -f "$PYTHON_BASE/.default_version" ]; then
        cat "$PYTHON_BASE/.default_version"
    elif [ -d "$PYTHON_BASE/current" ]; then
        # Assume que a current é a versão padrão
        echo "$($PYTHON_BASE/current/python --version) em '$PYTHON_BASE/current'"
    else
        # Fallback para primeira versão gerenciada pelo UV que encontrar
        local first_version=$(/bin/ls -d $PYTHON_BASE/*$version*/python.exe 2>/dev/null | head -1)
        echo "${first_version:-3.12}"
    fi
}


#-------------------------------------------------------------------------------------------
# Função para definir versão Python padrão
#-------------------------------------------------------------------------------------------
py-set-default() {
    local version="$1"
    local version_path="$PYTHON_BASE/$version"
    local current_path="$PYTHON_BASE/current"

    if [ -z "$version" ]; then
        echo "Uso: py-set-default <versão>"
        # Exibe as versões disponíveis
        echo ""
        py-versions
        return 1
    fi

    # Verificar se a versão está instalada
    if ! uv python list --only-installed | grep -q "$version"; then
        echo "Versão $version não está instalada. Você pode instalar a partir da lista a seguir."
        # Exibe as versões disponíveis
        py-versions
        return 1
    fi

    # Remover junction/symlink existente se houver
    if [ -L "$current_path" ] || [ -d "$current_path" ]; then
        echo "Removendo junction/symlink existente..."
        rm -rf "$current_path" 2>/dev/null || {
            echo "Erro: Não foi possível remover junction existente"
            echo "Tente executar manualmente: rmdir /Q \"$(cygpath -w "$current_path")\""
            return 1
        }
    fi

    # Recriar junction/symlink apontando para o diretório $PYTHON_BASE/current
    echo "Definindo $version_name como versão padrão..."
    echo "Nota: Esta operação requer a criação de um junction no Windows"
    echo "Se falhar, execute manualmente:"
    echo "  mklink /J \"$(cygpath -w "$current_path")\" \"$(cygpath -w "$version_path")\""
    if command -v cmd.exe &>/dev/null; then
        cmd.exe /c "mklink /J \"$(cygpath -w "$current_path")\" \"$(cygpath -w "$version_path")\"" 2>/dev/null && {
            echo "Junction criado com sucesso!"
            echo "Nova versão padrão: $($current_path/python.exe --version 2>/dev/null)"
            return 0
        }
    fi

    # Recriar shims
    _py-create-shims

    # Salvar versão padrão
    echo "$version" > "$PYTHON_BASE/.default_version"

    echo "Versão padrão definida para: $version"
}


#-------------------------------------------------------------------------------------------
# Função para criar shims do Python
#-------------------------------------------------------------------------------------------
_py-create-shims() {
    local python_version=$(py-get-default)
    local python_path=$(_uv-get-python-path "$python_version")

    # Criar diretório para shims se não existir
    mkdir -p "$PYTHON_SHIMS_DIR"

    if [ -n "$python_path" ] && [ -f "$python_path" ]; then
        echo "Criando shims para Python $python_version"

        # Remover shims antigos
        rm -f "$PYTHON_SHIMS_DIR/python"
        rm -f "$PYTHON_SHIMS_DIR/python3"
        rm -f "$PYTHON_SHIMS_DIR/pip"
        rm -f "$PYTHON_SHIMS_DIR/pip3"

        # Criar novos shims
        ln -sf "$python_path" "$PYTHON_SHIMS_DIR/python"
        ln -sf "$python_path" "$PYTHON_SHIMS_DIR/python3"

        # Criar symlink para pip (encontrar pip no mesmo diretório do python)
        local pip_path="${python_path%/*}/Scripts/pip.exe"
        if [ -f "$pip_path" ]; then
            ln -sf "$pip_path" "$PYTHON_SHIMS_DIR/pip"
            ln -sf "$pip_path" "$PYTHON_SHIMS_DIR/pip3"
        fi

        echo "Symlinks criados em: $PYTHON_SHIMS_DIR"
    else
        echo "Python não encontrado: $python_path"
        return 1
    fi
}


#-------------------------------------------------------------------------------------------
# Função para obter caminho do Python gerenciado pelo UV
#-------------------------------------------------------------------------------------------
_uv-get-python-path() {
    local version="$1"
    [ -z "$version" ] && version=$(py-get-default)

    # Tentar obter o caminho do Python via UV
    local python_path=$(uv python find "$version" 2>/dev/null)
    if [ -n "$python_path" ] && [ -f "$python_path" ]; then
        echo "$python_path"
    else
        # Fallback: procurar no diretório de instalação do UV
        ls -d $PYTHON_BASE/*$version*/python.exe 2>/dev/null || echo "Não encontrado" | head -1
    fi
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
    if [ "$1" = "--version" ]; then
        echo "pip is managed by uv; usage: 'uv pip [OPTIONS] <COMMAND>'"
    elif [ -f "pyproject.toml" ] && grep -q "tool.uv" "pyproject.toml" 2>/dev/null; then
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
        echo "  uv tool install <package>  # Para instalar globalmente"
        echo "  uv pip install <package>   # Para instalar no virtualenv corrente"
        return 1
    fi
}


#-------------------------------------------------------------------------------------------
# Aliases para facilitar o uso do Python
#-------------------------------------------------------------------------------------------
# alias python='_python_uv'
# alias pip='_pip_uv'


#-------------------------------------------------------------------------------------------
#--- Final do script 'python-functions.sh'
#-------------------------------------------------------------------------------------------