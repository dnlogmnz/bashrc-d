#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/bash-functions.sh
# Funções para facilitar o uso no Bash
# ==========================================================================================

#-------------------------------------------------------------------------------------------
# Função "echodo"
#-------------------------------------------------------------------------------------------
function echodo() {
    echo; echo "$LINHA"; echo "=== $*"; echo "$LINHA"
    $*
}


#-------------------------------------------------------------------------------------------
# Função "urlencode <string>"
#-------------------------------------------------------------------------------------------
function urlencode() {
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c";;
            *) printf '%%%02X' "'$c";;
        esac
    done
}


#-------------------------------------------------------------------------------------------
# Função "urldecode <string>"
#-------------------------------------------------------------------------------------------
function urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}


#-------------------------------------------------------------------------------------------
# Funções para exibir mensagens coloridas e de linha inteira no terminal
#-------------------------------------------------------------------------------------------

# Definir variaveis para cores no terminal
export colorTitle="$(printf '\e[48;5;44;38;5;0m')"  # Fundo cyan (44), texto preto (0)
export colorAction="$(printf '\e[36m')"             # Cor ciano para o texto da ação
export colorScript="$(printf '\e[33m')"             # Cor amarela para o nome do script
export colorReset="$(printf '\e[0m')"               # Resetar todas as as cores e formatações

# Funções para exibir mensagens
function displayTitle()  { printf "\n${colorReset}${colorTitle}\r%-*s${colorReset}\n" "${COLUMNS:-78}" ">>> $*"; }
function displayAction() { printf "${colorReset}${colorAction}%-s${colorReset}\n" ">>> $*"; }
function displayScript() { printf "${colorReset}${colorScript}%-s${colorReset}" "$*... "; }
function displayInfo()   { printf "${colorReset} - %-15s%s\n" "$1" "${2:+: ${*:2}}"; }


#-------------------------------------------------------------------------------------------
# Função para mostrar informações do ambiente
#-------------------------------------------------------------------------------------------
show-versions() {
    echo "=== Informações do Ambiente ==="
    echo "  APPS_BASE .............: $APPS_BASE"
    echo ""
    echo "=== Cloud CLI ==="
    echo "  AWS CLI ...............: $(aws --version 2>/dev/null || echo 'Não encontrado')"
    echo "  GCloud CLI ............: $(gcloud --version 2>/dev/null || echo 'Não encontrado' | head -1)"
    echo ""
    echo "=== DevSecOps ==="
    echo "  Docker ................: $(docker --version 2>/dev/null || echo 'Não encontrado')"
    echo "  Git ...................: $(git --version 2>/dev/null || echo 'Não encontrado')"
    echo "  Terraform .............: $(terraform --version 2>/dev/null || echo 'Não encontrado' | head -1)"
    echo ""
    echo "=== Linguagens ==="
    echo "  UV ....................: $(uv --version 2>/dev/null || echo 'Não encontrado')"
    echo "  Python ................: $(python --version 2>/dev/null || echo 'Não encontrado')"
    echo "  Node.js ...............: $(node --version 2>/dev/null || echo 'Não encontrado')"
    echo "  npm ...................: $(npm --version 2>/dev/null || echo 'Não encontrado')"
}

#-------------------------------------------------------------------------------------------
#--- Final do script 'bash-functions.sh'
#-------------------------------------------------------------------------------------------