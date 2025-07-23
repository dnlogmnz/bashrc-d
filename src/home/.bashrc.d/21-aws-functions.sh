#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/aws-functions.sh
# Funções para facilitar o uso do AWS CLI v2
# ==========================================================================================

#-------------------------------------------------------------------------------------------
# Função para mostrar informações da AWS
#-------------------------------------------------------------------------------------------
aws-info() {
    echo "=== Informações da AWS CLI ==="
    echo "Versão: $(aws --version 2>/dev/null || echo 'AWS CLI não encontrado')"
    echo "Executável: $(which aws 2>/dev/null || echo 'Não encontrado')"
    echo "Configuração: $AWS_CONFIG_FILE"
    echo "Credenciais: $AWS_SHARED_CREDENTIALS_FILE"
    echo "Região padrão: $AWS_DEFAULT_REGION"
    echo "Output padrão: $AWS_DEFAULT_OUTPUT"
    echo ""

    if command -v aws &> /dev/null; then
        echo "Perfil atual:"
        aws configure list 2>/dev/null || echo "Não configurado"
        echo ""
        echo "Identidade atual:"
        aws sts get-caller-identity 2>/dev/null || echo "Não autenticado"
        echo ""
        echo "Perfis disponíveis:"
        aws configure list-profiles 2>/dev/null || echo "Nenhum perfil encontrado"
    fi
}


#-------------------------------------------------------------------------------------------
# Função para configurar perfil AWS
#-------------------------------------------------------------------------------------------
aws-setup() {
    echo "Configurando perfil AWS..."
    read -p "Nome do perfil (default para padrão): " profile

    # Criar diretório se não existir
    mkdir -p "$(dirname "$AWS_CONFIG_FILE")"

    if [ -z "$profile" ] || [ "$profile" = "default" ]; then
        aws configure
    else
        aws configure --profile "$profile"
    fi

    echo "Perfil AWS configurado com sucesso!"
    aws-info
}


#-------------------------------------------------------------------------------------------
# Função para alternar entre perfis AWS
#-------------------------------------------------------------------------------------------
aws-use() {
    if [ -z "$1" ]; then
        echo "Uso: aws-use <perfil>"
        echo "Perfis disponíveis:"
        aws configure list-profiles 2>/dev/null || echo "Nenhum perfil encontrado"
        return 1
    fi

    local profile="$1"

    # Verificar se o perfil existe
    if ! aws configure list-profiles 2>/dev/null | grep -q "^$profile$"; then
        echo "Perfil '$profile' não encontrado"
        echo "Perfis disponíveis:"
        aws configure list-profiles 2>/dev/null
        return 1
    fi

    export AWS_PROFILE="$profile"
    echo "Perfil AWS ativo: $AWS_PROFILE"
    echo ""
    aws sts get-caller-identity 2>/dev/null || echo "Erro ao obter identidade"
}


#-------------------------------------------------------------------------------------------
# Função para remover perfil AWS
#-------------------------------------------------------------------------------------------
aws-remove-profile() {
    if [ -z "$1" ]; then
        echo "Uso: aws-remove-profile <perfil>"
        echo "Perfis disponíveis:"
        aws configure list-profiles 2>/dev/null || echo "Nenhum perfil encontrado"
        return 1
    fi

    local profile="$1"

    if [ "$profile" = "default" ]; then
        echo "Não é possível remover o perfil 'default'"
        return 1
    fi

    echo "Removendo perfil '$profile'..."
    aws configure set --profile "$profile" aws_access_key_id ""
    aws configure set --profile "$profile" aws_secret_access_key ""
    aws configure set --profile "$profile" region ""
    aws configure set --profile "$profile" output ""

    echo "Perfil '$profile' removido com sucesso!"
}


#-------------------------------------------------------------------------------------------
# Função para listar recursos AWS de forma resumida
#-------------------------------------------------------------------------------------------
aws-summary() {
    if ! command -v aws &> /dev/null; then
        echo "AWS CLI não encontrado"
        return 1
    fi

    echo "=== Resumo de Recursos AWS ==="
    echo "Perfil: ${AWS_PROFILE:-default}"
    echo "Região: $(aws configure get region 2>/dev/null || echo 'Não configurada')"
    echo ""

    echo "EC2 Instances:"
    aws ec2 describe-instances --query "Reservations[].Instances[?State.Name=='running'].{ID:InstanceId,Type:InstanceType}" --output table 2>/dev/null || echo "Erro ao listar instâncias"

    echo ""
    echo "S3 Buckets:"
    aws s3 ls 2>/dev/null | wc -l | xargs echo "Total:" || echo "Erro ao listar buckets"

    echo ""
    echo "Lambda Functions:"
    aws lambda list-functions --query "Functions[].FunctionName" --output table 2>/dev/null || echo "Erro ao listar funções"
}


#-------------------------------------------------------------------------------------------
# Função para configurar região AWS
#-------------------------------------------------------------------------------------------
aws-set-region() {
    if [ -z "$1" ]; then
        echo "Uso: aws-set-region <região>"
        echo "Exemplo: aws-set-region us-east-1"
        echo ""
        echo "Regiões disponíveis:"
        aws ec2 describe-regions --query "Regions[].RegionName" --output table 2>/dev/null || echo "Erro ao listar regiões"
        return 1
    fi

    local region="$1"
    local profile="${AWS_PROFILE:-default}"

    aws configure set region "$region" --profile "$profile"
    export AWS_DEFAULT_REGION="$region"

    echo "Região '$region' configurada para o perfil '$profile'"
}


#-------------------------------------------------------------------------------------------
# Função para verificar custos AWS (requer permissões de billing)
#-------------------------------------------------------------------------------------------
aws-costs() {
    local start_date=$(date -d "1 month ago" +%Y-%m-%d)
    local end_date=$(date +%Y-%m-%d)

    echo "Verificando custos de $start_date até $end_date..."

    aws ce get-cost-and-usage \
        --time-period Start="$start_date",End="$end_date" \
        --granularity MONTHLY \
        --metrics BlendedCost \
        --query "ResultsByTime[].Total.BlendedCost.Amount" \
        --output table 2>/dev/null || echo "Erro ao obter custos (verifique permissões de billing)"
}

#-------------------------------------------------------------------------------------------
#--- Final do script 'aws-functions.sh'
#-------------------------------------------------------------------------------------------