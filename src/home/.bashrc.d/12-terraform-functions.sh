#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/terraform-functions.sh
# Funções para facilitar o uso do Terraform/OpenTofu
# ==========================================================================================

#-------------------------------------------------------------------------------------------
# Função para mostrar informações do Terraform
#-------------------------------------------------------------------------------------------
tf-info() {
    echo "=== Informações do Terraform ==="
    echo "  Terraform executável ..: $(which terraform 2>/dev/null || echo 'Não encontrado')"
    echo "  Terraform versão ......: $(terraform version 2>/dev/null || echo 'Terraform não encontrado')"
    echo "  OpenTofu executável ...: $(which tofu 2>/dev/null || echo 'Não encontrado')"
    echo "  OpenTofu versão .......: $(tofu version 2>/dev/null || echo 'OpenTofu não encontrado')"
    echo "  Diretório de dados ....: $TF_DATA_DIR"
    echo "  Cache de plugins ......: $TF_PLUGIN_CACHE_DIR"
    echo ""

    if [ -d "$TF_DATA_DIR" ]; then
        echo "=== Estado atual do diretório corrente ==="
        echo "  Inicializado ..........: $([ -f "$TF_DATA_DIR/terraform.tfstate" ] && echo 'Sim' || echo 'Não')"
        echo "  Workspace .............: $(terraform workspace show 2>/dev/null || echo 'Não disponível')"
        echo "  Providers .............: $(ls -1 "$TF_DATA_DIR/providers" 2>/dev/null | wc -l || echo '0')"
    fi
}


#-------------------------------------------------------------------------------------------
# Função para inicializar projeto Terraform
#-------------------------------------------------------------------------------------------
tf-new-project() {
    local project_name="$1"

    if [ -z "$project_name" ]; then
        echo "Uso: tf-new-project <nome_do_projeto>"
        return 1
    fi

    echo "Criando projeto Terraform: $project_name"

    # Criar diretório do projeto
    mkdir -p "$project_name"
    cd "$project_name"

    # Criar estrutura básica
    cat > main.tf << 'EOF'
# Configuração do provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    # Adicione seus providers aqui
  }
}

# Configuração do backend (opcional)
# terraform {
#   backend "s3" {
#     bucket = "meu-terraform-state"
#     key    = "terraform.tfstate"
#     region = "us-east-1"
#   }
# }
EOF

    cat > variables.tf << 'EOF'
# Variáveis do projeto
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "my-project"
}
EOF

    cat > outputs.tf << 'EOF'
# Outputs do projeto
output "project_info" {
  description = "Project information"
  value = {
    name        = var.project_name
    environment = var.environment
  }
}
EOF

    cat > terraform.tfvars.example << 'EOF'
# Exemplo de variáveis
environment = "dev"
project_name = "my-project"
EOF

    echo "Projeto Terraform '$project_name' criado com sucesso!"
    echo "Próximos passos:"
    echo "1. Edite main.tf para configurar seus providers"
    echo "2. Execute: terraform init"
    echo "3. Execute: terraform plan"
}


#-------------------------------------------------------------------------------------------
# Função para validar e formatar código
#-------------------------------------------------------------------------------------------
tf-check() {
    echo "Verificando código Terraform..."

    # Formatar código
    echo "Formatando código..."
    terraform fmt -recursive

    # Validar sintaxe
    echo "Validando sintaxe..."
    if terraform validate; then
        echo "✓ Código válido"
    else
        echo "✗ Código inválido"
        return 1
    fi

    # Verificar segurança com tfsec (se disponível)
    if command -v tfsec &> /dev/null; then
        echo "Verificando segurança..."
        tfsec .
    fi
}


#-------------------------------------------------------------------------------------------
# Função para planejar com detalhes
#-------------------------------------------------------------------------------------------
tf-plan-detailed() {
    local plan_file="tfplan-$(date +%Y%m%d-%H%M%S)"

    echo "Criando plano detalhado: $plan_file"

    terraform plan -out="$plan_file" -detailed-exitcode
    local exit_code=$?

    case $exit_code in
        0)
            echo "✓ Nenhuma mudança necessária"
            rm -f "$plan_file"
            ;;
        1)
            echo "✗ Erro no plano"
            return 1
            ;;
        2)
            echo "✓ Plano criado com mudanças"
            echo "Para aplicar: terraform apply $plan_file"
            ;;
    esac
}


#-------------------------------------------------------------------------------------------
# Função para aplicar com backup
#-------------------------------------------------------------------------------------------
tf-apply-safe() {
    local backup_dir="terraform-backups/$(date +%Y%m%d-%H%M%S)"

    echo "Criando backup do estado atual..."
    mkdir -p "$backup_dir"

    if [ -f "terraform.tfstate" ]; then
        cp terraform.tfstate "$backup_dir/"
        echo "Backup salvo em: $backup_dir"
    fi

    echo "Aplicando mudanças..."
    terraform apply "$@"

    if [ $? -eq 0 ]; then
        echo "✓ Aplicação concluída com sucesso"
        echo "Backup disponível em: $backup_dir"
    else
        echo "✗ Erro na aplicação"
        return 1
    fi
}


#-------------------------------------------------------------------------------------------
# Função para listar recursos
#-------------------------------------------------------------------------------------------
tf-resources() {
    echo "=== Recursos do Terraform ==="

    if [ ! -f "terraform.tfstate" ]; then
        echo "Nenhum estado encontrado. Execute 'terraform init' primeiro."
        return 1
    fi

    echo "Recursos no estado:"
    terraform state list | sort

    echo ""
    echo "Contagem por tipo:"
    terraform state list | cut -d. -f1 | sort | uniq -c | sort -nr
}

#-------------------------------------------------------------------------------------------
# Função para limpar cache
#-------------------------------------------------------------------------------------------
tf-clean() {
    echo "Limpando cache do Terraform..."

    if [ -d "$TF_DATA_DIR" ]; then
        rm -rf "$TF_DATA_DIR"
        echo "✓ Cache local limpo"
    fi

    if [ -d "$TF_PLUGIN_CACHE_DIR" ]; then
        rm -rf "$TF_PLUGIN_CACHE_DIR"
        mkdir -p "$TF_PLUGIN_CACHE_DIR"
        echo "✓ Cache de plugins limpo"
    fi

    echo "Cache limpo! Execute 'terraform init' para reinicializar."
}


#-------------------------------------------------------------------------------------------
# Função para mostrar custos (requer infracost)
#-------------------------------------------------------------------------------------------
tf-costs() {
    if ! command -v infracost &> /dev/null; then
        echo "Infracost não encontrado. Instale em: https://www.infracost.io/docs/"
        return 1
    fi

    echo "Calculando custos da infraestrutura..."
    infracost breakdown --path .
}


#-------------------------------------------------------------------------------------------
# Função para mostrar workspaces
#-------------------------------------------------------------------------------------------
tf-workspaces() {
    echo "=== Workspaces do Terraform ==="
    terraform workspace list
    echo ""
    echo "Workspace atual: $(terraform workspace show)"
}


#-------------------------------------------------------------------------------------------
# Função para criar workspace
#-------------------------------------------------------------------------------------------
tf-new-workspace() {
    if [ -z "$1" ]; then
        echo "Uso: tf-new-workspace <nome>"
        return 1
    fi

    local workspace_name="$1"

    terraform workspace new "$workspace_name"
    echo "Workspace '$workspace_name' criado e ativado"
}

#-------------------------------------------------------------------------------------------
# Função para alternar workspace
#-------------------------------------------------------------------------------------------
tf-workspace-use() {
    if [ -z "$1" ]; then
        echo "Uso: tf-workspace-use <nome>"
        echo "Workspaces disponíveis:"
        terraform workspace list
        return 1
    fi

    local workspace_name="$1"

    terraform workspace select "$workspace_name"
    echo "Workspace ativo: $workspace_name"
}

#-------------------------------------------------------------------------------------------
#--- Final do script 'terraform-functions.sh'
#-------------------------------------------------------------------------------------------