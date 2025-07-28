#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/mongodb-functions.sh
# Funções para facilitar o uso das ferramentas CLI do MongoDB Atlas
# ==========================================================================================

#-------------------------------------------------------------------------------------------
# Função para carregar variáveis do arquivo .env
#-------------------------------------------------------------------------------------------
_load_mongodb_env() {
    local env_file="$HOME/.bashrc.d/.env"
    if [ -f "$env_file" ]; then
        source "$env_file"
    fi
}

#-------------------------------------------------------------------------------------------
# Função para mostrar informações do MongoDB
#-------------------------------------------------------------------------------------------
mongodb-info() {
    _load_mongodb_env
    
    echo "=== Informações do MongoDB ==="
    echo "  mongosh ...............: $(mongosh --version 2>/dev/null || echo 'Não encontrado')"
    echo "  mongoexport ...........: $(mongoexport --version 2>/dev/null || echo 'Não encontrado')"
    echo "  mongoimport ...........: $(mongoimport --version 2>/dev/null || echo 'Não encontrado')"
    echo "  mongodump .............: $(mongodump --version 2>/dev/null || echo 'Não encontrado')"
    echo "  mongorestore ..........: $(mongorestore --version 2>/dev/null || echo 'Não encontrado')"
    echo "  atlas: $(atlas --version 2>/dev/null || echo 'Não encontrado')"
    echo ""
    echo "=== Configuração atual ==="
    echo "  DB_USER ...............: ${DB_USER:-'Não configurado'}"
    echo "  DB_NAME ...............: ${DB_NAME:-'Não configurado'}"
    echo "  DB_HOST ...............: ${DB_HOST:-'Não configurado'}"
    echo "  DB_PASS ...............: $([ -n "$DB_PASS" ] && echo '***configurado***' || echo 'Não configurado')"
    echo "  Timeout ...............: ${MONGODB_TIMEOUT:-'30000'}ms"
    echo "  Export Format .........: ${MONGODB_EXPORT_FORMAT:-'json'}"
}

#-------------------------------------------------------------------------------------------
# Função para configurar conexão MongoDB
#-------------------------------------------------------------------------------------------
mongodb-setup() {
    local env_file="$HOME/.bashrc.d/.env"
    local backup_created=false
    
    # Verificar se o arquivo .env já existe e contém variáveis MongoDB
    if [ -f "$env_file" ]; then
        if grep -q "^DB_USER\|^DB_NAME\|^DB_HOST\|^DB_PASS" "$env_file"; then
            echo "AVISO: O arquivo $env_file já contém configurações do MongoDB."
            echo "Os valores atuais serão sobrescritos."
            read -p "Deseja continuar? (s/N): " confirm
            if [[ ! "$confirm" =~ ^[Ss]$ ]]; then
                echo "Configuração cancelada."
                return 1
            fi
            
            # Criar backup do arquivo existente
            cp "$env_file" "${env_file}.backup.$(date +%Y%m%d_%H%M%S)"
            backup_created=true
        fi
    else
        # Criar diretório se não existir
        mkdir -p "$(dirname "$env_file")"
        touch "$env_file"
        echo "Arquivo $env_file criado."
    fi

    echo "Configurando MongoDB..."
    read -p "DB_USER (usuário do banco): " db_user
    read -p "DB_NAME (nome do banco): " db_name
    read -p "DB_HOST (host do cluster): " db_host
    read -s -p "DB_PASS (senha): " db_pass
    echo # Nova linha após input oculto

    # Remover configurações antigas do MongoDB se existirem
    if [ -f "$env_file" ]; then
        grep -v "^DB_USER\|^DB_NAME\|^DB_HOST\|^DB_PASS" "$env_file" > "${env_file}.tmp" && mv "${env_file}.tmp" "$env_file"
    fi

    # Adicionar novas configurações
    cat >> "$env_file" << EOF

# MongoDB Configuration
export DB_USER="$db_user"
export DB_NAME="$db_name"
export DB_HOST="$db_host"
export DB_PASS="$db_pass"
EOF

    echo "MongoDB configurado com sucesso!"
    if [ "$backup_created" = true ]; then
        echo "Backup da configuração anterior criado."
    fi
    
    # Carregar as novas variáveis
    _load_mongodb_env
    mongodb-info
}

#-------------------------------------------------------------------------------------------
# Função para testar conexão
#-------------------------------------------------------------------------------------------
mongodb-test() {
    _load_mongodb_env
    
    if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ] || [ -z "$DB_HOST" ] || [ -z "$DB_NAME" ]; then
        echo "Configuração do MongoDB incompleta. Execute 'mongodb-setup' primeiro."
        return 1
    fi

    local mongodb_uri="mongodb+srv://$DB_USER:$DB_PASS@$DB_HOST/$DB_NAME"
    
    echo "Testando conexão com MongoDB..."
    mongosh "$mongodb_uri" --quiet --eval "db.runCommand('ping')" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "Conexão com MongoDB OK!"
    else
        echo "Erro na conexão com MongoDB"
        return 1
    fi
}

#-------------------------------------------------------------------------------------------
# Função para backup completo
#-------------------------------------------------------------------------------------------
mongodb-backup() {
    _load_mongodb_env
    local backup_dir="${1:-./mongodb-backup-$(date +%Y%m%d_%H%M%S)}"

    if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ] || [ -z "$DB_HOST" ] || [ -z "$DB_NAME" ]; then
        echo "Configuração do MongoDB incompleta. Execute 'mongodb-setup' primeiro."
        return 1
    fi

    local mongodb_uri="mongodb+srv://$DB_USER:$DB_PASS@$DB_HOST/$DB_NAME"
    
    echo "Criando backup em: $backup_dir"
    mongodump --uri="$mongodb_uri" --gzip --out="$backup_dir"

    if [ $? -eq 0 ]; then
        echo "Backup criado com sucesso em: $backup_dir"
    else
        echo "Erro ao criar backup"
        return 1
    fi
}

#-------------------------------------------------------------------------------------------
# Função para restaurar backup
#-------------------------------------------------------------------------------------------
mongodb-restore() {
    _load_mongodb_env
    local backup_dir="$1"

    if [ -z "$backup_dir" ]; then
        echo "Uso: mongodb-restore <diretório-do-backup>"
        return 1
    fi

    if [ ! -d "$backup_dir" ]; then
        echo "Diretório de backup não encontrado: $backup_dir"
        return 1
    fi

    if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ] || [ -z "$DB_HOST" ] || [ -z "$DB_NAME" ]; then
        echo "Configuração do MongoDB incompleta. Execute 'mongodb-setup' primeiro."
        return 1
    fi

    local mongodb_uri="mongodb+srv://$DB_USER:$DB_PASS@$DB_HOST/$DB_NAME"
    
    echo "Restaurando backup de: $backup_dir"
    mongorestore --uri="$mongodb_uri" --gzip "$backup_dir"

    if [ $? -eq 0 ]; then
        echo "Backup restaurado com sucesso!"
    else
        echo "Erro ao restaurar backup"
        return 1
    fi
}

#-------------------------------------------------------------------------------------------
# Função para exportar coleção
#-------------------------------------------------------------------------------------------
mongodb-export-collection() {
    _load_mongodb_env
    local collection="$1"
    local output_file="${2:-${collection}_$(date +%Y%m%d_%H%M%S).json}"

    if [ -z "$collection" ]; then
        echo "Uso: mongodb-export-collection <coleção> [arquivo-saída]"
        return 1
    fi

    if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ] || [ -z "$DB_HOST" ] || [ -z "$DB_NAME" ]; then
        echo "Configuração do MongoDB incompleta. Execute 'mongodb-setup' primeiro."
        return 1
    fi

    local mongodb_uri="mongodb+srv://$DB_USER:$DB_PASS@$DB_HOST/$DB_NAME"
    
    echo "Exportando coleção '$collection' para: $output_file"
    mongoexport --uri="$mongodb_uri" --db="$DB_NAME" --collection="$collection" --out="$output_file" --jsonArray --pretty

    if [ $? -eq 0 ]; then
        echo "Coleção exportada com sucesso!"
    else
        echo "Erro ao exportar coleção"
        return 1
    fi
}

#-------------------------------------------------------------------------------------------
# Função para importar coleção
#-------------------------------------------------------------------------------------------
mongodb-import-collection() {
    _load_mongodb_env
    local collection="$1"
    local input_file="$2"

    if [ -z "$collection" ] || [ -z "$input_file" ]; then
        echo "Uso: mongodb-import-collection <coleção> <arquivo-entrada>"
        return 1
    fi

    if [ ! -f "$input_file" ]; then
        echo "Arquivo não encontrado: $input_file"
        return 1
    fi

    if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ] || [ -z "$DB_HOST" ] || [ -z "$DB_NAME" ]; then
        echo "Configuração do MongoDB incompleta. Execute 'mongodb-setup' primeiro."
        return 1
    fi

    local mongodb_uri="mongodb+srv://$DB_USER:$DB_PASS@$DB_HOST/$DB_NAME"
    
    echo "Importando arquivo '$input_file' para coleção '$collection'..."
    mongoimport --uri="$mongodb_uri" --db="$DB_NAME" --collection="$collection" --file="$input_file" --jsonArray

    if [ $? -eq 0 ]; then
        echo "Dados importados com sucesso!"
    else
        echo "Erro ao importar dados"
        return 1
    fi
}

#-------------------------------------------------------------------------------------------
#--- Final do script 'mongodb-functions.sh'
#-------------------------------------------------------------------------------------------