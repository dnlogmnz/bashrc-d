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

# Ajustar o PATH: caso existir "/usr/local/bin", adicionar ao PATH
[ -d "/usr/local/bin" ] && [[ "$PATH" = "/usr/local/bin" ]] || export PATH=$PATH:/usr/local/bin

#-------------------------------------------------------------------------------------------
#--- Final do script 'bash-envs.sh'
#-------------------------------------------------------------------------------------------