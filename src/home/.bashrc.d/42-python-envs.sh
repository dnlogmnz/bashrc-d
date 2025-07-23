#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/python-envs.sh
# Variaveis de ambiente para o Python gerenciado pelo UV
# ==========================================================================================

# Configurações do Python
export PYTHONIOENCODING="utf-8"
export PYTHONDONTWRITEBYTECODE="1" # Não gerar arquivos .pyc (melhora performance em containers/CI)
export PYTHONUNBUFFERED="1" # Saída não bufferizada (importante para logs em tempo real)
export PYTHON_HISTORY="$APPS_BASE/python/.python_history" # Histórico do Python REPL (persiste comandos entre sessões)

# Configurações do pip (caso seja usado diretamente)
export PIP_REQUIRE_VIRTUALENV="true"  # Sempre usar ambiente virtual
export PIP_DISABLE_PIP_VERSION_CHECK="1"  # Não verificar atualizações do pip

#-------------------------------------------------------------------------------------------
#--- Final do script 'python-envs.sh'
#-------------------------------------------------------------------------------------------