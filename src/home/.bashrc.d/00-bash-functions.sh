#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/bash-functions.sh
# Funções para facilitar o uso do Bash
# ==========================================================================================

#-------------------------------------------------------------------------------------------
# Função "echodo"
#-------------------------------------------------------------------------------------------
function echodo() {
    echo; echo "$LINHA"; echo "=== $*"; echo "$LINHA"
    $*
}


#-------------------------------------------------------------------------------------------
# Funções para exibir mensagens coloridas e de linha inteira no terminal
#-------------------------------------------------------------------------------------------

# Definir variaveis para cores no terminal
export colorTitle="$(printf '\e[48;5;44;38;5;0m')" # 5: paleta de 256 cores; 48: fundo, 44: Ciano; 38: frente, 0: preto
export colorAction="$(printf '\e[36m')"     # 36: Ciano
export colorScript="$(printf '\e[33m')"     # 33: Amarelo
export colorSuccess="$(printf '\e[1;32m')"  # 1: Negrito, 32: Verde
export colorFailure="$(printf '\e[1;31m')"  # 1: Negrito, 31: Vermelho
export colorWarning="$(printf '\e[1;33m')"  # 1: Negrito, 33: Amarelo
export colorReset="$(printf '\e[0m')"       # Reset de todas as as cores e formatações

# Funções para exibir mensagens
function displayTitle()   { printf '%s%-*s%s\n' "${colorTitle}" "${COLUMNS:-78}" ">>> $*" "${colorReset}"; }
function displayAction()  { printf '%s>>> %s%s\n' "${colorReset}${colorAction}" "$*" "${colorReset}"; }
function displayScript()  { printf '%s%s... %s' "${colorReset}${colorScript}" "$*" "${colorReset}"; }
function displayInfo()    { printf '%s - %-15s%s%s\n' "${colorReset}" "$1" "${colorReset}" "${2:+: ${*:2}}"; }
function displaySuccess() { printf '%s[%s]%s %s\n' "${colorReset}${colorSuccess}" "$1" "${colorReset}" "$2"; }
function displayFailure() { printf '%s[%s]%s %s\n' "${colorReset}${colorFailure}" "$1" "${colorReset}" "$2"; }
function displayWarning() { printf '%s[%s]%s %s\n' "${colorReset}${colorWarning}" "$1" "${colorReset}" "$2"; }


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
#--- Final do script '~/.bashrc.d/bash-functions.sh'
#-------------------------------------------------------------------------------------------