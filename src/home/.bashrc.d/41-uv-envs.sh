#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/uv-envs.sh
# Variaveis de ambiente para o UV (Python Package Manager)
# ==========================================================================================

# Diretórios do UV
export UV_HOME="${APPS_BASE}/uv"                  # diretório base do uv
export UV_CONFIG_FILE="$UV_HOME/uv.toml"          # arquivo de configuração global do uv
export UV_INSTALL_DIR="$UV_HOME/bin"              # binários: uv.exe, uvw.exe, uvx.exe
export UV_CACHE_DIR="$UV_HOME/cache"              # cache das packages python
export UV_TOOL_DIR="$UV_HOME/tools"               # ferramentas do uv: ruff, black, etc
export UV_PYTHON_INSTALL_DIR="$APPS_BASE/Python"       # diretóro contendo as diferentes versões do Python
export UV_PYTHON_BIN_DIR="$UV_PYTHON_INSTALL_DIR/bin"  # shims do Python: links para os executáveis do Python

# Configurações do UV
export UV_LINK_MODE="copy"
UV_PYTHON_INSTALL_REGISTRY="1"  # registrar as instalações do Python no Windows Registry
UV_PYTHON_DOWNLOADS="manual"    # desabilita os downloads automáticos do Python pelo uv
# export UV_NATIVE_TLS="1"      # Usa os certificados do Windows (SChannel)

#  Adicionar UV ao PATH
if [ -d "${UV_INSTALL_DIR}" ]; then
    if [[ ":$PATH:" != *":${UV_INSTALL_DIR}:"* ]]; then
        displayWarning "Aviso" "Recomendável adicionar \"$UV_INSTALL_DIR\" ao PATH do Windows"
        export PATH="${UV_INSTALL_DIR}:$PATH"
    fi
    if [[ ":$PATH:" != *":${UV_TOOL_DIR}/bin:"* ]]; then
        displayWarning "Aviso" "Recomendável adicionar \"$UV_TOOL_DIR/bin\" ao PATH do Windows"
        export PATH="${UV_TOOL_DIR}/bin:$PATH"
    fi
fi

# Criar arquivo "uv.toml", caso ainda não existir
[ -r "$UV_CONFIG_FILE" ] || cat >"$UV_CONFIG_FILE" << EOF
# =============================================================================
# Arquivo: D:\\%USERNAME%\\Apps\\uv\\uv.toml
# Configuração global do UV
# =============================================================================

# Configurações gerais
link-mode = "copy"
python-downloads = "manual"

# Diretórios
cache-dir = "$UV_CACHE_DIR"
EOF

# Habilitar o autocompletion para comandos uv e uvx
echo 'eval "$(uv generate-shell-completion bash)"' 1> /tmp/uv-autocompletion.sh 2>/dev/null
echo 'eval "$(uvx --generate-shell-completion bash)"' 1>> /tmp/uv-autocompletion.sh 2>/dev/null
source /tmp/uv-autocompletion.sh
rm -f /tmp/uv-autocompletion.sh

#-------------------------------------------------------------------------------------------
#--- Final do script 'uv-envs.sh'
#-------------------------------------------------------------------------------------------