#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/terraform-envs.sh
# Variaveis de ambiente para o Terraform/OpenTofu
# ==========================================================================================

# Configuração do Terraform
export TERRAFORM_HOME="${APPS_BASE}/utils"
export TF_DATA_DIR=".terraform"
export TF_LOG_PATH="terraform.log"
export TF_INPUT=false
export TF_PLUGIN_CACHE_DIR="${APPS_BASE}/terraform/plugin-cache"
export TF_CLI_CONFIG_FILE="$APPS_BASE/terraform/terraformrc"

# Configurações do OpenTofu
export TOFU_CLI_CONFIG_FILE="${APPS_BASE}/opentofu/tofurc"
export TOFU_DATA_DIR="${APPS_BASE}/opentofu"
export TOFU_PLUGIN_CACHE_DIR="${APPS_BASE}/opentofu/plugins"
export TOFU_LOG_PATH="${APPS_BASE}/opentofu/tofu.log"

# Adiciona "/usr/local/bin" ao PATH
if [ -d "$TERRAFORM_HOME" ]; then
    if [[ ":$PATH:" != *":$TERRAFORM_HOME:"* ]]; then
        displayWarning "Aviso" "Recomendável adicionar \"$TERRAFORM_HOME\" ao PATH do Windows"
        export PATH="$TERRAFORM_HOME:$PATH"
    fi
fi

#-------------------------------------------------------------------------------------------
#--- Final do script 'terraform-envs.sh'
#-------------------------------------------------------------------------------------------