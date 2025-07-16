#!/bin/bash
# =============================================================================
# Arquivo: base-envs.sh
# Variáveis de ambiente para o Bash
# =============================================================================

# Diretório base para aplicações e ferramentas.
export APPS_BASE="/d/${USERNAME}/Apps"

# Variáveis "LINHA" e "TRACO"
LINHA="$(for i in `seq 1 112`; do echo -e "="; done)"
TRACO="$(for i in `seq 1 112`; do echo -e "-"; done)"

# Ajustar PATH: remover entradas duplicadas e algumas "sobras"
PATH="$( echo $PATH \
       | tr ':' '\n' \
       | awk '! a[$0]++' \
       | egrep -v '/(Microsoft VS|PyCharm)' \
       | tr '\n' ':')"
export PATH=${PATH::-1}

# Ajustar o PATH: caso existir "/usr/local/bin", adicionar ao PATH
[ -d "/usr/local/bin" ] && [[ "$PATH" = "/usr/local/bin" ]] || export PATH=$PATH:/usr/local/bin

#--------------------------------------------------------------------------------
#--- Final do script
#--------------------------------------------------------------------------------