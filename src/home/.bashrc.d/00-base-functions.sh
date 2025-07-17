#!/bin/bash
# =========================================================================================
# Arquivo: base-functions.sh
# Funções para uso no Bash
# =========================================================================================

#------------------------------------------------------------------------------------------
# Função "echodo"
#------------------------------------------------------------------------------------------
function echodo() {
    echo; echo "$LINHA"; echo "=== $*"; echo "$LINHA"
    $*
}


#------------------------------------------------------------------------------------------
# Função "urlencode <string>"
#------------------------------------------------------------------------------------------
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


#------------------------------------------------------------------------------------------
# Função "urldecode <string>"
#------------------------------------------------------------------------------------------
function urldecode() {
    local url_encoded="${1//+/ }"
    printf 'b' "${url_encoded//%/\\x}"
}


#------------------------------------------------------------------------------------------
# Função para mostrar informações do ambiente
#------------------------------------------------------------------------------------------
show-versions() {
    echo "=== Informações do Ambiente ==="
    echo "APPS_BASE .............: $APPS_BASE"
    echo "AWS CLI ...............: $(aws --version 2>/dev/null || echo 'Não encontrado')"
    echo "GCloud CLI ............: $(gcloud --version 2>/dev/null || echo 'Não encontrado' | head -1)"
    echo "Docker ................: $(docker --version 2>/dev/null || echo 'Não encontrado')"
    echo "Git ...................: $(git --version 2>/dev/null || echo 'Não encontrado')"
    echo "Node.js ...............: $(node --version 2>/dev/null || echo 'Não encontrado')"
    echo "Python ................: $(python --version 2>/dev/null || echo 'Não encontrado')"
    echo "Terraform .............: $(terraform --version 2>/dev/null || echo 'Não encontrado' | head -1)"
    echo "UV ....................: $(uv --version 2>/dev/null || echo 'Não encontrado')"
}

#------------------------------------------------------------------------------------------
#--- Final do script
#------------------------------------------------------------------------------------------