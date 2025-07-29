#
# =============================================================================
# Script: ~/.bashrc
# Executado por shells interativos.
# Define variáveis e carrega os scripts rc.
# =============================================================================

# Configurações de locale
export LANG=pt_BR.UTF-8
export LC_ALL=pt_BR.UTF-8

# Configurações gerais do bash
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:erasedups

# Executar os scripts (run commands) de configuração de ambiente
for rc in ~/.bashrc.d/*.sh; do
    [ -r "$rc" ] && source $rc
done

# Limpa a variável rc do escopo global
unset rc

#--------------------------------------------------------------------------------
#--- Final do script 'bashrc'
#--------------------------------------------------------------------------------