#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/mongodb-envs.sh
# Variáveis de ambiente para MongoDB Atlas tools
# ==========================================================================================

# Configuração de diretórios contendo clientes do MongoDB
export MONGODB_HOME="${APPS_BASE}/MongoDB"
export MONGOSH_HOME="${APPS_BASE}/MongoDB/mongosh"
export ATLAS_CLI_HOME="${APPS_BASE}/MongoDB/atlas-cli"

# Configurações para MongoDB
export MONGODB_TIMEOUT=30000         # timeout para operações
export MONGODB_EXPORT_FORMAT="json"  # Configuração de formato de saída padrão
unset MONGODB_URI                    # Será configurado por projeto
unset MONGODB_DATABASE               # Será configurado por projeto

# Adicionar MongoDB tools ao PATH
if [ -d "$MONGODB_HOME/bin" ]; then
    if [[ ":$PATH:" != *":${MONGODB_HOME}/bin:"* ]]; then
        export PATH="$MONGODB_HOME/bin:$PATH"
    fi
fi

# Adicionar mongosh ao PATH
if [ -d "$MONGOSH_HOME/bin" ]; then
    if [[ ":$PATH:" != *":${MONGOSH_HOME}/bin:"* ]];then
        displayWarning "Aviso" "Recomendável adicionar \"$MONGOSH_HOME/bin\" ao PATH do Windows"
        export PATH="$MONGOSH_HOME/bin:$PATH"
    fi
fi

# Adicionar Atlas CLI ao PATH
if [ -d "$ATLAS_CLI_HOME/bin" ]; then
    if [[ ":$PATH:" != *":${ATLAS_CLI_HOME}/bin:"* ]]; then
        displayWarning "Aviso" "Recomendável adicionar \"$ATLAS_CLI_HOME/bin\" ao PATH do Windows"
        export PATH="$ATLAS_CLI_HOME/bin:$PATH"
    fi
fi

#-------------------------------------------------------------------------------------------
#--- Final do script 'mongodb-envs.sh'
#-------------------------------------------------------------------------------------------