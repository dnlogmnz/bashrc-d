#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/node-envs.sh
# Variaveis de ambiente para o Node.js
# ==========================================================================================

# Configuração do Node.js
export NODE_HOME="${APPS_BASE}/node"
export NODE_CURRENT="${NODE_HOME}/current"  # Link simbólico para versão atual
export NODE_REPL_HISTORY="${APPS_BASE}/node/history"

# Adicionar Node.js ao PATH
if [ -d "$NODE_CURRENT" ]; then
    if [[ ":$PATH:" != *":$NODE_CURRENT:"* ]]; then
        displayWarning "Aviso" "Recomendável adicionar \"$NODE_CURRENT\" ao PATH do Windows"
        export PATH=$PATH:"$NODE_CURRENT:$PATH"
    fi
fi

# Configurações do NPM
export NPM_CONFIG_PREFIX="${NODE_HOME}/.npm-global"
export NPM_CONFIG_CACHE="${NODE_HOME}/.npm-cache"
export NPM_CONFIG_REGISTRY="https://registry.npmjs.org/"
export NPM_CONFIG_USERCONFIG="${NODE_HOME}/npm/npmrc"

# Adicionar pacotes globais do NPM ao PATH
if [ -d "$NPM_CONFIG_PREFIX/bin" ]; then
    if [[ ":$PATH:" != *":$NPM_CONFIG_PREFIX/bin:"* ]]; then
        displayWarning "Aviso" "Recomendável adicionar \"$NPM_CONFIG_PREFIX/bin\" ao PATH do Windows"
        export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
    fi
fi

#-------------------------------------------------------------------------------------------
#--- Final do script 'node-envs.sh'
#-------------------------------------------------------------------------------------------