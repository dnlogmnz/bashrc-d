#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/gcloud-envs.sh
# Variaveis de ambiente para o Google Cloud CLI
# ==========================================================================================

# Configuração do Google Cloud CLI
export GCLOUD_HOME="${APPS_BASE}/google/gcloud"
export CLOUDSDK_CONFIG="${APPS_BASE}/google/gcloud/config"
export CLOUDSDK_PYTHON="python3"
export CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true
export CLOUDSDK_SURVEY_DISABLE_PROMPTS=true

# Adicionar Google Cloud CLI ao PATH
if [ -d "$GCLOUD_HOME/bin" ]; then
    if [[ ":$PATH:" != *":${GCLOUD_HOME}/bin:"* ]]; then
        displayWarning "Aviso" "Recomendável adicionar \"$GCLOUD_HOME/bin\" ao PATH do Windows"
        export PATH="$GCLOUD_HOME/bin:$PATH"
    fi
fi

#-------------------------------------------------------------------------------------------
#--- Final do script 'gcloud-envs.sh'
#-------------------------------------------------------------------------------------------