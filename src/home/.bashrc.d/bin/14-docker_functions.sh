#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/docker-functions.sh
# Funções para facilitar o uso do Docker Desktop
# ==========================================================================================

#-------------------------------------------------------------------------------------------
# Função para mostrar informações do Docker
#-------------------------------------------------------------------------------------------
docker-info() {
    echo "=== Informações do Docker ==="
    echo "  Docker ................: $(docker --version 2>/dev/null || echo 'Não encontrado')"
    echo "  Docker Compose ........: $(docker-compose --version 2>/dev/null || echo 'Não encontrado')"
    echo "  Docker Desktop ........: $(docker info --format '{{.ServerVersion}}' 2>/dev/null || echo 'Não conectado')"
    echo ""
    echo "=== Configuração atual ==="
    echo "  BuildKit ..............: ${DOCKER_BUILDKIT:-'Não configurado'}"
    echo "  Registry ..............: ${DOCKER_REGISTRY:-'Não configurado'}"
    echo "  Namespace .............: ${DOCKER_NAMESPACE:-'Não configurado'}"
    echo "  Client Timeout ........: ${DOCKER_CLIENT_TIMEOUT:-'120'}s"
    echo ""
    echo "=== Status dos recursos ==="
    echo "  Containers ............: $(docker ps -q | wc -l) rodando / $(docker ps -aq | wc -l) total"
    echo "  Images ................: $(docker images -q | wc -l) total"
    echo "  Volumes ...............: $(docker volume ls -q | wc -l) total"
    echo "  Networks ..............: $(docker network ls -q | wc -l) total"
}

#-------------------------------------------------------------------------------------------
# Função para configurar Docker
#-------------------------------------------------------------------------------------------
docker-setup() {
    echo "Configurando Docker..."
    read -p "Registry URL (ex: registry.hub.docker.com): " registry
    read -p "Namespace/Organização (ex: myorg): " namespace

    export DOCKER_REGISTRY="$registry"
    export DOCKER_NAMESPACE="$namespace"

    echo "Docker configurado com sucesso!"
    docker-info
}

#-------------------------------------------------------------------------------------------
# Função para testar Docker
#-------------------------------------------------------------------------------------------
docker-test() {
    echo "Testando Docker..."

    # Testar se o daemon está rodando
    docker info > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✓ Docker daemon está rodando"
    else
        echo "✗ Docker daemon não está rodando"
        return 1
    fi

    # Testar execução de container
    docker run --rm hello-world > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✓ Execução de containers OK"
    else
        echo "✗ Erro na execução de containers"
        return 1
    fi

    # Testar Docker Compose
    docker-compose --version > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "✓ Docker Compose disponível"
    else
        echo "✗ Docker Compose não encontrado"
    fi

    echo "Teste do Docker concluído!"
}

#-------------------------------------------------------------------------------------------
# Função para limpeza completa
#-------------------------------------------------------------------------------------------
docker-cleanup() {
    echo "Executando limpeza completa do Docker..."

    # Parar todos os containers
    echo "Parando containers em execução..."
    docker stop $(docker ps -q) 2>/dev/null

    # Remover containers parados
    echo "Removendo containers parados..."
    docker container prune -f

    # Remover imagens não utilizadas
    echo "Removendo imagens não utilizadas..."
    docker image prune -a -f

    # Remover volumes não utilizados
    echo "Removendo volumes não utilizados..."
    docker volume prune -f

    # Remover networks não utilizadas
    echo "Removendo networks não utilizadas..."
    docker network prune -f

    # Remover build cache
    echo "Removendo build cache..."
    docker builder prune -f

    echo "Limpeza completa finalizada!"
    docker-info
}

#-------------------------------------------------------------------------------------------
# Função para construir e executar aplicação
#-------------------------------------------------------------------------------------------
docker-dev() {
    local service="${1:-app}"

    if [ ! -f "docker-compose.yml" ] && [ ! -f "Dockerfile" ]; then
        echo "Nenhum arquivo Docker encontrado (docker-compose.yml ou Dockerfile)"
        return 1
    fi

    if [ -f "docker-compose.yml" ]; then
        echo "Executando com Docker Compose..."
        docker-compose up --build "$service"
    elif [ -f "Dockerfile" ]; then
        echo "Executando com Dockerfile..."
        docker build -t temp-app .
        docker run -it --rm temp-app
    fi
}

#-------------------------------------------------------------------------------------------
# Função para logs de todos os containers
#-------------------------------------------------------------------------------------------
docker-logs-all() {
    local tail_lines="${1:-50}"

    echo "Mostrando logs de todos os containers..."
    for container in $(docker ps --format "table {{.Names}}" | tail -n +2); do
        echo "$LINHA"
        echo "=== Logs do container: $container ==="
        echo "$LINHA"
        docker logs --tail="$tail_lines" "$container"
        echo ""
    done
}

#-------------------------------------------------------------------------------------------
# Função para entrar em container
#-------------------------------------------------------------------------------------------
docker-shell() {
    local container="$1"
    local shell="${2:-bash}"

    if [ -z "$container" ]; then
        echo "Containers disponíveis:"
        docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
        echo ""
        read -p "Digite o nome do container: " container
    fi

    if [ -z "$container" ]; then
        echo "Nome do container é obrigatório"
        return 1
    fi

    echo "Entrando no container '$container' com shell '$shell'..."
    docker exec -it "$container" "$shell" 2>/dev/null || \
    docker exec -it "$container" sh 2>/dev/null || \
    echo "Erro: não foi possível acessar o container"
}

#-------------------------------------------------------------------------------------------
# Função para monitorar recursos
#-------------------------------------------------------------------------------------------
docker-monitor() {
    echo "Monitorando recursos do Docker (Ctrl+C para sair)..."
    docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}"
}

#-------------------------------------------------------------------------------------------
# Função para backup de volumes
#-------------------------------------------------------------------------------------------
docker-backup-volume() {
    local volume="$1"
    local backup_file="${2:-${volume}_backup_$(date +%Y%m%d_%H%M%S).tar.gz}"

    if [ -z "$volume" ]; then
        echo "Volumes disponíveis:"
        docker volume ls --format "table {{.Name}}\t{{.Driver}}"
        echo ""
        read -p "Digite o nome do volume: " volume
    fi

    if [ -z "$volume" ]; then
        echo "Nome do volume é obrigatório"
        return 1
    fi

    echo "Criando backup do volume '$volume' em '$backup_file'..."
    docker run --rm -v "$volume":/source -v "$(pwd)":/backup alpine tar czf "/backup/$backup_file" -C /source .

    if [ $? -eq 0 ]; then
        echo "Backup criado com sucesso: $backup_file"
    else
        echo "Erro ao criar backup"
        return 1
    fi
}

#-------------------------------------------------------------------------------------------
# Função para restaurar volumes
#-------------------------------------------------------------------------------------------
docker-restore-volume() {
    local volume="$1"
    local backup_file="$2"

    if [ -z "$volume" ] || [ -z "$backup_file" ]; then
        echo "Uso: docker-restore-volume <volume> <arquivo-backup>"
        return 1
    fi

    if [ ! -f "$backup_file" ]; then
        echo "Arquivo de backup não encontrado: $backup_file"
        return 1
    fi

    echo "Restaurando volume '$volume' do backup '$backup_file'..."
    docker run --rm -v "$volume":/target -v "$(pwd)":/backup alpine tar xzf "/backup/$backup_file" -C /target

    if [ $? -eq 0 ]; then
        echo "Volume restaurado com sucesso!"
    else
        echo "Erro ao restaurar volume"
        return 1
    fi
}

#-------------------------------------------------------------------------------------------
#--- Final do script 'docker_functions.sh'
#-------------------------------------------------------------------------------------------