#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/python-envs.sh
# Variáveis de ambiente para o Python
# ==========================================================================================

# Diretório base do Python
export PYTHON_BASE="${APPS_BASE}/Python"

# Diretório para shims do Python (deve estar no PATH)
export PYTHON_SHIMS_DIR="$PYTHON_BASE/bin"

# Codificação para operações de I/O (read/write de arquivos, interação com o console)
export PYTHONIOENCODING="utf-8"

# Configurações específicas para "localhost": NÃO DEVEM SER USADAS EM AMBIENTES TESTING, STAGING NEM PRODUCTION 
export PYTHONDONTWRITEBYTECODE="1"  # Acelera import de módulos ao não criar arquivos .pyc (bytecode)
export PYTHONUNBUFFERED="1"  # Não bufferizar saída, implica em exibir os logs em tempo real (útil para desenvolvedor)
export PYTHON_HISTORY="$PYTHON_BASE/.python_history"  # Histórico do Python REPL (persiste comandos entre sessões)

# Adicionar Python atual ao PATH
if [ -d "$PYTHON_BASE/current" ]; then
    if [[ ":$PATH:" != *":${PYTHON_BASE}/current:"* ]]; then
        displayWarning "Aviso" "Recomendável adicionar \"$PYTHON_BASE/current\" ao PATH do Windows"
        export PATH="$PYTHON_BASE/current:$PATH"
    fi
fi

# Adicionar shims do UV ao PATH (para gerenciamento de versões)
if [ -d "$PYTHON_SHIMS_DIR" ]; then
    if [[ ":$PATH:" != *":${PYTHON_SHIMS_DIR}:"* ]]; then
        displayWarning "Aviso" "Recomendável adicionar \"$PYTHON_SHIMS_DIR\" ao PATH do Windows"
        export PATH="$PYTHON_SHIMS_DIR:$PATH"
    fi
fi


#-------------------------------------------------------------------------------------------
#--- Final do script '~/.bashrc.d/python-envs.sh'
#-------------------------------------------------------------------------------------------