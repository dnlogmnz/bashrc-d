#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/gcloud-functions.sh
# Funções para facilitar o uso do Google Cloud CLI
# ==========================================================================================

#-------------------------------------------------------------------------------------------
# Função para mostrar informações do Google Cloud
#-------------------------------------------------------------------------------------------
gcp-info() {
    echo "=== Informações do Google Cloud CLI ==="
    echo "  Versão: $(gcloud --version 2>/dev/null | head -1 || echo 'Google Cloud CLI não encontrado')"
    echo "  Executável: $(which gcloud 2>/dev/null || echo 'Não encontrado')"
    echo "  Configuração: $CLOUDSDK_CONFIG"
    echo "  Python: $CLOUDSDK_PYTHON"

    echo ""
    if command -v gcloud &> /dev/null; then
        echo "=== Configuração atual ==="
        gcloud config list 2>/dev/null || echo "Não configurado"

        echo ""
        echo "=== Contas autenticadas ==="
        gcloud auth list 2>/dev/null || echo "Nenhuma conta autenticada"

        echo ""
        echo "=== Projetos disponíveis ==="
        gcloud projects list --limit=10 2>/dev/null || echo "Erro ao listar projetos"
    fi
}


#-------------------------------------------------------------------------------------------
# Função para configurar Google Cloud
#-------------------------------------------------------------------------------------------
gcp-setup() {
    echo "Configurando Google Cloud CLI..."

    # Criar diretório se não existir
    mkdir -p "$CLOUDSDK_CONFIG"

    # Inicializar configuração
    gcloud init

    echo "Google Cloud CLI configurado com sucesso!"
    gcp-info
}


#-------------------------------------------------------------------------------------------
# Função para autenticar com Google Cloud
#-------------------------------------------------------------------------------------------
gcp-login() {
    echo "Iniciando autenticação com Google Cloud..."
    gcloud auth login

    echo "Autenticação concluída!"
    gcp-info
}


#-------------------------------------------------------------------------------------------
# Função para alternar entre projetos
#-------------------------------------------------------------------------------------------
gcp-use() {
    if [ -z "$1" ]; then
        echo "Uso: gcp-use <project-id>"
        echo "Projetos disponíveis:"
        gcloud projects list --format="value(projectId)" 2>/dev/null || echo "Nenhum projeto encontrado"
        return 1
    fi

    local project_id="$1"

    # Verificar se o projeto existe
    if ! gcloud projects describe "$project_id" &>/dev/null; then
        echo "Projeto '$project_id' não encontrado ou sem acesso"
        echo "Projetos disponíveis:"
        gcloud projects list --format="value(projectId)" 2>/dev/null
        return 1
    fi

    gcloud config set project "$project_id"
    echo "Projeto ativo: $project_id"
    echo ""

    # Mostrar informações do projeto
    gcloud projects describe "$project_id" --format="value(name,projectId,lifecycleState)" 2>/dev/null
}


#-------------------------------------------------------------------------------------------
# Função para configurar região padrão
#-------------------------------------------------------------------------------------------
gcp-set-region() {
    if [ -z "$1" ]; then
        echo "Uso: gcp-set-region <região>"
        echo "Exemplo: gcp-set-region us-central1"
        echo ""
        echo "Regiões disponíveis:"
        gcloud compute regions list --format="value(name)" 2>/dev/null | head -10
        return 1
    fi

    local region="$1"

    gcloud config set compute/region "$region"
    echo "Região padrão configurada: $region"
}


#-------------------------------------------------------------------------------------------
# Função para configurar zona padrão
#-------------------------------------------------------------------------------------------
gcp-set-zone() {
    if [ -z "$1" ]; then
        echo "Uso: gcp-set-zone <zona>"
        echo "Exemplo: gcp-set-zone us-central1-a"
        echo ""
        echo "Zonas disponíveis:"
        gcloud compute zones list --format="value(name)" 2>/dev/null | head -10
        return 1
    fi

    local zone="$1"

    gcloud config set compute/zone "$zone"
    echo "Zona padrão configurada: $zone"
}


#-------------------------------------------------------------------------------------------
# Função para listar configurações
#-------------------------------------------------------------------------------------------
gcp-configurations() {
    echo "=== Configurações do Google Cloud ==="
    gcloud config configurations list 2>/dev/null || echo "Erro ao listar configurações"
}

#-------------------------------------------------------------------------------------------
# Função para criar nova configuração
#-------------------------------------------------------------------------------------------
gcp-create-config() {
    if [ -z "$1" ]; then
        echo "Uso: gcp-create-config <nome>"
        echo "Exemplo: gcp-create-config desenvolvimento"
        return 1
    fi

    local config_name="$1"

    gcloud config configurations create "$config_name"
    echo "Configuração '$config_name' criada com sucesso!"

    # Ativar a nova configuração
    gcloud config configurations activate "$config_name"
    echo "Configuração '$config_name' ativada"
}


#-------------------------------------------------------------------------------------------
# Função para alternar entre configurações
#-------------------------------------------------------------------------------------------
gcp-use-config() {
    if [ -z "$1" ]; then
        echo "Uso: gcp-use-config <nome>"
        echo "Configurações disponíveis:"
        gcloud config configurations list --format="value(name)" 2>/dev/null
        return 1
    fi

    local config_name="$1"

    gcloud config configurations activate "$config_name"
    echo "Configuração ativa: $config_name"
    echo ""
    gcloud config list 2>/dev/null
}


#-------------------------------------------------------------------------------------------
# Função para resumo de recursos
#-------------------------------------------------------------------------------------------
gcp-summary() {
    if ! command -v gcloud &> /dev/null; then
        echo "Google Cloud CLI não encontrado"
        return 1
    fi

    local project=$(gcloud config get-value project 2>/dev/null)

    echo "=== Resumo de Recursos Google Cloud ==="
    echo "Projeto: ${project:-'Não configurado'}"
    echo "Região: $(gcloud config get-value compute/region 2>/dev/null || echo 'Não configurada')"
    echo "Zona: $(gcloud config get-value compute/zone 2>/dev/null || echo 'Não configurada')"
    echo ""

    if [ -n "$project" ]; then
        echo "Instâncias Compute Engine:"
        gcloud compute instances list --limit=5 --format="table(name,zone,status)" 2>/dev/null || echo "Erro ao listar instâncias"

        echo ""
        echo "Buckets Cloud Storage:"
        gcloud storage buckets list --limit=5 --format="value(name)" 2>/dev/null | wc -l | xargs echo "Total:" || echo "Erro ao listar buckets"

        echo ""
        echo "Funções Cloud Functions:"
        gcloud functions list --limit=5 --format="value(name)" 2>/dev/null | wc -l | xargs echo "Total:" || echo "Erro ao listar funções"
    fi
}


#-------------------------------------------------------------------------------------------
# Função para atualizar componentes
#-------------------------------------------------------------------------------------------
gcp-update() {
    echo "Atualizando componentes do Google Cloud CLI..."
    gcloud components update
    echo "Atualização concluída!"
}


#-------------------------------------------------------------------------------------------
# Função para instalar componentes adicionais
#-------------------------------------------------------------------------------------------
gcp-install-components() {
    echo "Componentes disponíveis:"
    gcloud components list --only-local-state --format="table(id,name,size.size(zero=''))" 2>/dev/null
    echo ""
    echo "Para instalar: gcloud components install <component-id>"
    echo "Exemplo: gcloud components install kubectl"
}

#-------------------------------------------------------------------------------------------
#--- Final do script 'gcloud-functions.sh'
#-------------------------------------------------------------------------------------------