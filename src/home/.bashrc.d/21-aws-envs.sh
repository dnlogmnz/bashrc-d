#!/bin/bash
# =============================================================================
# Arquivo: aws-envs.sh
# Variaveis de ambiente para o AWS CLI v2
# =============================================================================

# Configuração do AWS CLI
export AWS_CONFIG_FILE="$APPS_BASE/aws/config"
export AWS_SHARED_CREDENTIALS_FILE="$APPS_BASE/aws/credentials"
export AWS_DEFAULT_REGION="ca-central-1"
export AWS_DEFAULT_OUTPUT="json"

# Configurações do AWS CDK
export CDK_CACHE_DIR="${XDG_CACHE_HOME}/aws-cdk"

# Adicionar AWS CLI ao PATH
if [ -d "$AWS_HOME/bin" ]; then
    export PATH="$AWS_HOME/bin:$PATH"
fi

#--------------------------------------------------------------------------------
#--- Final do script
#--------------------------------------------------------------------------------