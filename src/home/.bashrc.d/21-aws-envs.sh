#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/aws-envs.sh
# Variaveis de ambiente para o AWS CLI v2
# ==========================================================================================

# Configuração do AWS CLI
export AWS_HOME="$APPS_BASE/Amazon"
export AWS_CONFIG_FILE="$USERPROFILE/.aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$USERPROFILE/.aws/credentials"
export AWS_DEFAULT_OUTPUT="json"

# Configurações do AWS CDK
export CDK_CACHE_DIR="${APPS_BASE}/aws-cdk"

# Adicionar Docker ao PATH (caso não esteja no PATH do sistema)
if [ -d "$AWS_HOME/bin" ]; then
    if [[ ":$PATH:" != *":$AWS_HOME/bin:"* ]]; then
        displayWarning "Aviso" "Recomendável adicionar \"$AWS_HOME/bin\" ao PATH do Windows"
        export PATH="$AWS_HOME/bin:$PATH"
    fi
fi


#-------------------------------------------------------------------------------------------
#--- Final do script 'aws-envs.sh'
#-------------------------------------------------------------------------------------------