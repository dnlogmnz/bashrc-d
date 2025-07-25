#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/bash-envs.sh
# Variáveis de ambiente para o Bash
# ==========================================================================================

# Diretório base para aplicações e ferramentas.
export APPS_BASE="/d/${USERNAME}/Apps"

# Variáveis "LINHA" e "TRACO"
LINHA="$(for i in `seq 1 112`; do echo -n "="; done)"
TRACO="$(for i in `seq 1 112`; do echo -n "-"; done)"

# Ajustar PATH: remover entradas duplicadas e algumas "sobras"
PATH="$( echo $PATH \
       | tr ':' '\n' \
       | awk '! linha[$0]++' \
       | egrep -v '/(Microsoft VS|PyCharm)' \
       | tr '\n' ':')"
export PATH=${PATH::-1}

# Adiciona "/usr/local/bin" ao PATH
if [ -d "/usr/local/bin" ]; then
    [[ ":$PATH:" != *":/usr/local/bin:"* ]] && export PATH="/usr/local/bin:$PATH"
fi

#-------------------------------------------------------------------------------------------
#--- Final do script 'bash-envs.sh'
#-------------------------------------------------------------------------------------------