#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/gemini-cli-functions.sh
# Funções para facilitar o uso do Google Cloud CLI
# ==========================================================================================

#-------------------------------------------------------------------------------------------
# Função para verificar configuração
#-------------------------------------------------------------------------------------------
function gemini-info() {

    echo "=== Gemini CLI - Chaves de API =="
    if [[ -n "$GOOGLE_API_KEY" ]]; then
        echo "  GOOGLE_API_KEY ........: Configurada (${GOOGLE_API_KEY:0:10}...)"
    elif [[ -n "$GEMINI_API_KEY" ]]; then
        echo "  GEMINI_API_KEY ........: Configurada (${GEMINI_API_KEY:0:10}...)"
    else
        echo "  API Key: Não configurada"
    fi

    echo ""
    echo "=== Gemini CLI - Vertex AI =="
    if [[ "$GOOGLE_GENAI_USE_VERTEXAI" == "true" ]]; then
        echo "  Vertex AI..............: Habilitado"
        echo "    Project ....: ${GOOGLE_CLOUD_PROJECT:-'Não configurado'}"
        echo "    Location ...: ${GOOGLE_CLOUD_LOCATION}"
    else
        echo "  Vertex AI .............: Desabilitado"
    fi

    echo ""
    echo "=== Gemini CLI - Modelo =="
    echo "  Modelo ................: $GEMINI_MODEL"
    echo "  Temperatura ...........: $GEMINI_TEMPERATURE"
    echo "  Tema ..................: $GEMINI_CLI_THEME"
    echo "  Log Level .............: $GEMINI_CLI_LOG_LEVEL"

    echo ""
    echo "=== Gemini CLI - Diretórios =="
    echo "  Config Dir ............: $GEMINI_CLI_CONFIG_DIR"
    echo "  Cache Dir .............: $GEMINI_CLI_CACHE_DIR"
    echo "  Workspace .............: $GEMINI_CLI_WORKSPACE"
}


#-------------------------------------------------------------------------------------------
# Função para configurar API Key interativamente
#-------------------------------------------------------------------------------------------
function gemini-setup-api-key() {
    echo "Configuração da API Key do Gemini"
    echo "================================================================================"
    echo "1. Acesse: https://ai.google.dev/gemini-api/docs/api-key"
    echo "2. Crie uma nova API Key"
    echo "3. Cole a chave abaixo:"
    echo ""
    read -p "API Key: " -s api_key
    echo ""

    if [[ -n "$api_key" ]]; then
        echo "export GOOGLE_API_KEY=\"$api_key\"" >> "$HOME/.bashrc.d/gemini-cli.sh"
        export GOOGLE_API_KEY="$api_key"
        echo "API Key configurada com sucesso!"
        echo "Reinicie seu terminal ou execute: source ~/.bashrc"
    else
        echo "API Key não fornecida"
    fi
}


#-------------------------------------------------------------------------------------------
# Função para configurar Vertex AI
#-------------------------------------------------------------------------------------------
function gemini-setup-vertex-ai() {
    echo "Configuração do Vertex AI"
    echo "================================================================================"
    read -p "Google Cloud Project ID: " project_id
    read -p "Google Cloud Location [us-central1]: " location
    location=${location:-us-central1}

    if [[ -n "$project_id" ]]; then
        {
            echo "export GOOGLE_CLOUD_PROJECT=\"$project_id\""
            echo "export GOOGLE_CLOUD_LOCATION=\"$location\""
            echo "export GOOGLE_GENAI_USE_VERTEXAI=\"true\""
        } >> "$HOME/.bashrc.d/gemini-cli.sh"

        export GOOGLE_CLOUD_PROJECT="$project_id"
        export GOOGLE_CLOUD_LOCATION="$location"
        export GOOGLE_GENAI_USE_VERTEXAI="true"

        echo "Vertex AI configurado com sucesso!"
        echo "Certifique-se de ter o gcloud CLI configurado"
        echo "Execute: gcloud auth application-default login"
    else
        echo "Project ID não fornecido"
    fi
}


#-------------------------------------------------------------------------------------------
# Função para limpar cache
#-------------------------------------------------------------------------------------------
function gemini-clear-cache() {
    if [[ -d "$GEMINI_CLI_CACHE_DIR" ]]; then
        rm -rf "$GEMINI_CLI_CACHE_DIR"/*
        echo "Cache limpo com sucesso!"
    else
        echo "Cache não encontrado"
    fi
}


#-------------------------------------------------------------------------------------------
# Função para criar diretórios necessários
#-------------------------------------------------------------------------------------------
function gemini-create-dirs() {
    mkdir -p "$GEMINI_CLI_CONFIG_DIR"
    mkdir -p "$GEMINI_CLI_CACHE_DIR"
    mkdir -p "$GEMINI_CLI_LOG_DIR"
    mkdir -p "$GEMINI_CLI_WORKSPACE"
    echo "Diretórios criados com sucesso!"
}


#-------------------------------------------------------------------------------------------
# Função para exibir informações de ajuda resumidas
#-------------------------------------------------------------------------------------------
function gemini-help() {
    cat << 'EOF'
Google Gemini CLI - Guia de Uso

COMANDOS PRINCIPAIS:
  gemini              - Iniciar sessão interativa
  gemini "prompt"     - Executar prompt único
  /auth              - Gerenciar autenticação
  /model             - Trocar modelo
  /theme             - Trocar tema
  @file              - Referenciar arquivo
  !comando           - Executar comando do sistema

FUNÇÕES UTILITÁRIAS:
  gemini-config-check     - Verificar configuração
  gemini-setup-api-key    - Configurar API Key
  gemini-setup-vertex-ai  - Configurar Vertex AI
  gemini-clear-cache      - Limpar cache
  gemini-create-dirs        - Criar diretórios
  gemini-help            - Mostrar esta ajuda

VARIÁVEIS IMPORTANTES:
  GOOGLE_API_KEY         - Chave da API (prioritária)
  GEMINI_API_KEY         - Chave da API (alternativa)
  GEMINI_MODEL           - Modelo a ser usado
  GEMINI_CLI_THEME       - Tema da interface
  GEMINI_CLI_LANGUAGE    - Idioma padrão

DOCUMENTAÇÃO:
  https://github.com/google-gemini/gemini-cli
EOF
}


#-------------------------------------------------------------------------------------------
# Inicialização automática
#-------------------------------------------------------------------------------------------

if [[ "$GEMINI_CLI_ENABLE_CONFIG" == "true" ]]; then

    # Criar diretórios necessários se não existirem
    gemini-create-dirs 2>/dev/null

    # Verificar se há comandos gemini disponíveis
    if command -v gemini &> /dev/null; then
        echo "Gemini CLI detectado - Configurações carregadas"
    else
        echo "Gemini CLI não detectado - Instale com: npm install -g @google-ai/gemini-cli"
    fi

fi

#-------------------------------------------------------------------------------------------
#--- Final do script 'gemini-cli-functions.sh'
#-------------------------------------------------------------------------------------------