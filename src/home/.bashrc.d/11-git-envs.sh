#!/bin/bash
# =========================================================================================
# Arquivo: git-envs.sh
# Variaveis de ambiente para o Git
# =========================================================================================
# https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables

# Configuração do Git
export GIT_HOME="${APPS_BASE}/Git"
# export GIT_EDITOR=code
# export GIT_PAGER=less

# Adicionar Git ao PATH
if [ -d "$GIT_HOME/bin" ]; then
    [[ ":$PATH:" != *":${GIT_HOME}/bin:"* ]] && export PATH="$GIT_HOME/bin:$PATH"
fi

# Auto-completar para Git se disponível
if [ -f "$GIT_HOME/etc/bash_completion.d/git-completion.bash" ]; then
    source "$GIT_HOME/etc/bash_completion.d/git-completion.bash"
fi

#------------------------------------------------------------------------------------------
#--- Final do script
#------------------------------------------------------------------------------------------