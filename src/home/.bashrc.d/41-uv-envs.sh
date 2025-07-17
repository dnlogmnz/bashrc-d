#!/bin/bash
# =========================================================================================
# Arquivo: uv-envs.sh
# Variaveis de ambiente para o UV (Python Package Manager)
# =========================================================================================

# Diretórios do UV
export UV_INSTALL_DIR="$APPS_BASE/uv/bin"
export UV_CACHE_DIR="$APPS_BASE/uv/cache"
export UV_TOOL_DIR="$APPS_BASE/uv/tools"
export UV_CONFIG_FILE="$APPS_BASE/uv/uv.toml"
export UV_PYTHON_INSTALL_DIR="$APPS_BASE/python"

# Configurações do UV
export UV_COMPILE_BYTECODE="1"               # Compila bytecode para melhor performance
export UV_LINK_MODE="copy"
export UV_PYTHON_PREFERENCE="only-managed"   # Usa apenas Python gerenciado pelo UV

#  Adicionar UV ao PATH
[ -f "${UV_INSTALL_DIR}/env" ] && source "${UV_INSTALL_DIR}/env"
[[ ":$PATH:" != *":${UV_INSTALL_DIR}:"* ]] && export PATH="${UV_INSTALL_DIR}:$PATH"
[[ ":$PATH:" != *":${UV_TOOL_DIR}/bin:"* ]] && export PATH="${UV_TOOL_DIR}/bin:$PATH"

# Habilitar o autocompletion para comandos uv e uvx
echo 'eval "$(uv generate-shell-completion bash)"' 1> /tmp/uv-autocompletion.sh 2>/dev/null
echo 'eval "$(uvx --generate-shell-completion bash)"' 1>> /tmp/uv-autocompletion.sh 2>/dev/null
source /tmp/uv-autocompletion.sh
rm -f /tmp/uv-autocompletion.sh

#------------------------------------------------------------------------------------------
#--- Final do script
#------------------------------------------------------------------------------------------