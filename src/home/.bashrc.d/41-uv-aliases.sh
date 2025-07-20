#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/uv-aliases.sh
# Aliases para facilitar o uso do UV
# ==========================================================================================

# UV shortcuts
alias uv-list="uv python list"
alias uv-install="uv python install"
alias uv-sync="uv sync --dev"

# Python version management
alias py-versions="uv python list"
alias py-install="uv python install"

# Virtual environment management
alias venv-create="uv venv"
alias venv-activate="source .venv/bin/activate"
alias venv-deactivate="deactivate"

# ==========================================================================================


#-------------------------------------------------------------------------------------------
#--- Final do script 'uv-aliases.sh'
#-------------------------------------------------------------------------------------------