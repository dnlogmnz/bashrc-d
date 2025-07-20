#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/docker-envs.sh
# Variáveis de ambiente para Docker Desktop
# ==========================================================================================

# Configuração do Docker
export DOCKER_HOME="${APPS_BASE}/Docker"
export DOCKER_DESKTOP_HOME="/mnt/c/Program Files/Docker/Docker"

# Configurações para Docker
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_SCAN_SUGGEST=false

# Configurações de timeout
export DOCKER_CLIENT_TIMEOUT=120
export COMPOSE_HTTP_TIMEOUT=120

# Configuração de formato de saída
export DOCKER_CLI_HINTS=false

# Adicionar Docker ao PATH (caso não esteja no PATH do sistema)
if [ -d "$DOCKER_HOME/bin" ]; then
    [[ ":$PATH:" != *":${DOCKER_HOME}/bin:"* ]] && export PATH="$DOCKER_HOME/bin:$PATH"
fi

# Configuração para Docker Compose
export COMPOSE_CONVERT_WINDOWS_PATHS=1

# Configuração de registry padrão (pode ser alterado por projeto)
export DOCKER_REGISTRY=""
export DOCKER_NAMESPACE=""

#-------------------------------------------------------------------------------------------
#--- Final do script 'docker-envs.sh'
#-------------------------------------------------------------------------------------------