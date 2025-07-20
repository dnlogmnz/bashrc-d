#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/docker-aliases.sh
# Aliases para facilitar o uso do Docker Desktop
# ==========================================================================================

# Aliases básicos do Docker
alias d="docker"
alias di="docker images"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dls="docker images"

# Aliases para Docker Compose
alias dc="docker-compose"
alias dcup="docker-compose up"
alias dcdown="docker-compose down"
alias dcbuild="docker-compose build"
alias dcrestart="docker-compose restart"
alias dclogs="docker-compose logs"
alias dcps="docker-compose ps"

# Aliases para limpeza
alias docker-clean="docker system prune -f"
alias docker-clean-all="docker system prune -a -f"
alias docker-clean-volumes="docker volume prune -f"
alias docker-clean-networks="docker network prune -f"

# Aliases para containers
alias docker-stop-all="docker stop \$(docker ps -q)"
alias docker-rm-all="docker rm \$(docker ps -aq)"
alias docker-rmi-dangling="docker rmi \$(docker images -f 'dangling=true' -q)"

# Aliases para logs
alias docker-logs="docker logs -f"
alias docker-logs-tail="docker logs --tail=50 -f"

# Aliases para execução
alias docker-exec="docker exec -it"
alias docker-run="docker run -it --rm"

# Aliases para informações
alias docker-info="docker info"
alias docker-version="docker version"
alias docker-stats="docker stats"

#-------------------------------------------------------------------------------------------
#--- Final do script 'docker-aliases.sh'
#-------------------------------------------------------------------------------------------