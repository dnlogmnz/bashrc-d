#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/mongodb-functions.sh
# Funções para facilitar o uso das ferramentas CLI do MongoDB Atlas
# ==========================================================================================

#-------------------------------------------------------------------------------------------
# Função para mostrar informações do MongoDB
#-------------------------------------------------------------------------------------------
mongodb-info() {
    echo "=== Informações do MongoDB ==="
    echo "mongosh: $(mongosh --version 2>/dev/null || echo 'Não encontrado')"
    echo "mongoexport: $(mongoexport --version 2>/dev/null || echo 'Não encontrado')"
    echo "mongoimport: $(mongoimport --version 2>/dev/null || echo 'Não encontrado')"
    echo "mongodump: $(mongodump --version 2>/dev/null || echo 'Não encontrado')"
    echo "mongorestore: $(mongorestore --version 2>/dev/null || echo 'Não encontrado')"
    echo "atlas: $(atlas --version 2>/dev/null || echo 'Não encontrado')"
    echo ""
    echo "=== Configuração atual ==="
    echo "  MongoDB URI: ${MONGODB_URI:-'Não configurado'}"
    echo "  Database: ${MONGODB_DATABASE:-'Não configurado'}"
    echo "  Timeout: ${MONGODB_TIMEOUT:-'30000'}ms"
    echo "  Export Format: ${MONGODB_EXPORT_FORMAT:-'json'}"
}

#-------------------------------------------------------------------------------------------
# Função para configurar conexão MongoDB
#-------------------------------------------------------------------------------------------
mongodb-setup() {
    echo "Configurando MongoDB..."
    read -p "MongoDB URI (ex: mongodb+srv://user:pass@cluster.mongodb.net/): " uri
    read -p "Database padrão: " database

    export MONGODB_URI="$uri"
    export MONGODB_DATABASE="$database"

    echo "MongoDB configurado com sucesso!"
    mongodb-info
}

#-------------------------------------------------------------------------------------------
# Função para testar conexão
#-------------------------------------------------------------------------------------------
mongodb-test() {
    if [ -z "$MONGODB_URI" ]; then
        echo "MongoDB URI não configurado. Execute 'mongodb-setup' primeiro."
        return 1
    fi

    echo "Testando conexão com MongoDB..."
    mongosh "$MONGODB_URI" --quiet --eval "db.runCommand('ping')" 2>/dev/null
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
    local backup_dir="${1:-./mongodb-backup-$(date +%Y%m%d_%H%M%S)}"

    if [ -z "$MONGODB_URI" ]; then
        echo "MongoDB URI não configurado. Execute 'mongodb-setup' primeiro."
        return 1
    fi

    echo "Criando backup em: $backup_dir"
    mongodump --uri="$MONGODB_URI" --gzip --out="$backup_dir"

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
    local backup_dir="$1"

    if [ -z "$backup_dir" ]; then
        echo "Uso: mongodb-restore <diretório-do-backup>"
        return 1
    fi

    if [ ! -d "$backup_dir" ]; then
        echo "Diretório de backup não encontrado: $backup_dir"
        return 1
    fi

    if [ -z "$MONGODB_URI" ]; then
        echo "MongoDB URI não configurado. Execute 'mongodb-setup' primeiro."
        return 1
    fi

    echo "Restaurando backup de: $backup_dir"
    mongorestore --uri="$MONGODB_URI" --gzip "$backup_dir"

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
    local collection="$1"
    local output_file="${2:-${collection}_$(date +%Y%m%d_%H%M%S).json}"

    if [ -z "$collection" ]; then
        echo "Uso: mongodb-export-collection <coleção> [arquivo-saída]"
        return 1
    fi

    if [ -z "$MONGODB_URI" ] || [ -z "$MONGODB_DATABASE" ]; then
        echo "MongoDB URI/Database não configurados. Execute 'mongodb-setup' primeiro."
        return 1
    fi

    echo "Exportando coleção '$collection' para: $output_file"
    mongoexport --uri="$MONGODB_URI" --db="$MONGODB_DATABASE" --collection="$collection" --out="$output_file" --jsonArray --pretty

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

    if [ -z "$MONGODB_URI" ] || [ -z "$MONGODB_DATABASE" ]; then
        echo "MongoDB URI/Database não configurados. Execute 'mongodb-setup' primeiro."
        return 1
    fi

    echo "Importando arquivo '$input_file' para coleção '$collection'..."
    mongoimport --uri="$MONGODB_URI" --db="$MONGODB_DATABASE" --collection="$collection" --file="$input_file" --jsonArray

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