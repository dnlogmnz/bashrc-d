#!/bin/bash
# =============================================================================
# Arquivo: gemini-cli-envs.sh
# Variaveis de ambiente para o Google Gemini CLI
# =============================================================================

# ===============================================================================
# CONFIGURAÇÕES PRINCIPAIS
# ===============================================================================

# Definir se deve carregar configurações (útil para debug)
export GEMINI_CLI_ENABLE_CONFIG=${GEMINI_CLI_ENABLE_CONFIG:-false}

if [[ "$GEMINI_CLI_ENABLE_CONFIG" == "true" ]]; then
    
    # ===============================================================================
    # AUTENTICAÇÃO - API KEY (Método Principal)
    # ===============================================================================
    
    # Chave da API do Gemini (obtida em https://ai.google.dev/gemini-api/docs/api-key)
    # Prioridade: GOOGLE_API_KEY > GEMINI_API_KEY
    export GOOGLE_API_KEY="${GOOGLE_API_KEY:-}"
    export GEMINI_API_KEY="${GEMINI_API_KEY:-}"
    
    # ===============================================================================
    # AUTENTICAÇÃO - VERTEX AI (Para uso corporativo)
    # ===============================================================================
    
    # Configurações para Vertex AI
    export GOOGLE_CLOUD_PROJECT="${GOOGLE_CLOUD_PROJECT:-}"
    export GOOGLE_CLOUD_LOCATION="${GOOGLE_CLOUD_LOCATION:-us-central1}"
    
    # Habilitar uso do Vertex AI
    export GOOGLE_GENAI_USE_VERTEXAI="${GOOGLE_GENAI_USE_VERTEXAI:-false}"
    
    # Credenciais do Google Cloud (JSON key file)
    export GOOGLE_APPLICATION_CREDENTIALS="${GOOGLE_APPLICATION_CREDENTIALS:-}"
    
    # ===============================================================================
    # CONFIGURAÇÕES DE MODELO E COMPORTAMENTO
    # ===============================================================================
    
    # Modelo padrão a ser usado
    export GEMINI_MODEL="${GEMINI_MODEL:-gemini-2.0-flash-exp}"
    
    # Temperatura para controle da criatividade (0.0 a 2.0)
    export GEMINI_TEMPERATURE="${GEMINI_TEMPERATURE:-0.7}"
    
    # Número máximo de tokens na resposta
    export GEMINI_MAX_OUTPUT_TOKENS="${GEMINI_MAX_OUTPUT_TOKENS:-8192}"
    
    # Top-p para controle de diversidade
    export GEMINI_TOP_P="${GEMINI_TOP_P:-0.95}"
    
    # Top-k para controle de diversidade
    export GEMINI_TOP_K="${GEMINI_TOP_K:-40}"
    
    # ===============================================================================
    # CONFIGURAÇÕES DE INTERFACE E TEMA
    # ===============================================================================
    
    # Tema da interface (dark, light, auto)
    export GEMINI_CLI_THEME="${GEMINI_CLI_THEME:-auto}"
    
    # Idioma padrão
    export GEMINI_CLI_LANGUAGE="${GEMINI_CLI_LANGUAGE:-pt-BR}"
    
    # Habilitar cores no output
    export GEMINI_CLI_COLORS="${GEMINI_CLI_COLORS:-true}"
    
    # Habilitar markdown rendering
    export GEMINI_CLI_MARKDOWN="${GEMINI_CLI_MARKDOWN:-true}"
    
    # ===============================================================================
    # CONFIGURAÇÕES DE LOGGING E DEBUG
    # ===============================================================================
    
    # Nível de log (error, warn, info, debug)
    export GEMINI_CLI_LOG_LEVEL="${GEMINI_CLI_LOG_LEVEL:-info}"
    
    # Habilitar logging detalhado
    export GEMINI_CLI_VERBOSE="${GEMINI_CLI_VERBOSE:-false}"
    
    # Diretório para logs
    export GEMINI_CLI_LOG_DIR="${GEMINI_CLI_LOG_DIR:-$HOME/.gemini-cli/logs}"
    
    # ===============================================================================
    # CONFIGURAÇÕES DE CACHE E PERFORMANCE
    # ===============================================================================
    
    # Diretório de cache
    export GEMINI_CLI_CACHE_DIR="${GEMINI_CLI_CACHE_DIR:-$HOME/.gemini-cli/cache}"
    
    # Habilitar cache de respostas
    export GEMINI_CLI_CACHE_ENABLED="${GEMINI_CLI_CACHE_ENABLED:-true}"
    
    # Tempo de vida do cache (em segundos)
    export GEMINI_CLI_CACHE_TTL="${GEMINI_CLI_CACHE_TTL:-3600}"
    
    # ===============================================================================
    # CONFIGURAÇÕES DE SEGURANÇA
    # ===============================================================================
    
    # Timeout para requisições (em segundos)
    export GEMINI_CLI_TIMEOUT="${GEMINI_CLI_TIMEOUT:-30}"
    
    # Número máximo de tentativas
    export GEMINI_CLI_MAX_RETRIES="${GEMINI_CLI_MAX_RETRIES:-3}"
    
    # Habilitar verificação de certificados SSL
    export GEMINI_CLI_SSL_VERIFY="${GEMINI_CLI_SSL_VERIFY:-true}"
    
    # ===============================================================================
    # CONFIGURAÇÕES DE PROJETO E CONTEXTO
    # ===============================================================================
    
    # Diretório de configurações do usuário
    export GEMINI_CLI_CONFIG_DIR="${GEMINI_CLI_CONFIG_DIR:-$HOME/.gemini-cli}"
    
    # Arquivo de configurações personalizadas
    export GEMINI_CLI_CONFIG_FILE="${GEMINI_CLI_CONFIG_FILE:-$GEMINI_CLI_CONFIG_DIR/settings.json}"
    
    # Diretório de trabalho padrão
    export GEMINI_CLI_WORKSPACE="${GEMINI_CLI_WORKSPACE:-$HOME/workspace}"
    
    # ===============================================================================
    # CONFIGURAÇÕES DE INTEGRAÇÃO COM FERRAMENTAS
    # ===============================================================================
    
    # Habilitar integração com Git
    export GEMINI_CLI_GIT_INTEGRATION="${GEMINI_CLI_GIT_INTEGRATION:-true}"
    
    # Habilitar integração com VS Code
    export GEMINI_CLI_VSCODE_INTEGRATION="${GEMINI_CLI_VSCODE_INTEGRATION:-true}"
    
    # Editor padrão para comandos que requerem edição
    export GEMINI_CLI_EDITOR="${GEMINI_CLI_EDITOR:-${EDITOR:-nano}}"
    
    
    # Função para verificar configuração
    function gemini-config-check() {
        echo "Verificando configuração do Gemini CLI..."
        echo "================================================================================"
        
        # Verificar chaves de API
        if [[ -n "$GOOGLE_API_KEY" ]]; then
            echo "GOOGLE_API_KEY: Configurada (${GOOGLE_API_KEY:0:10}...)"
        elif [[ -n "$GEMINI_API_KEY" ]]; then
            echo "GEMINI_API_KEY: Configurada (${GEMINI_API_KEY:0:10}...)"
        else
            echo "API Key: Não configurada"
        fi
        
        # Verificar Vertex AI
        if [[ "$GOOGLE_GENAI_USE_VERTEXAI" == "true" ]]; then
            echo "Vertex AI: Habilitado"
            echo "   Project: ${GOOGLE_CLOUD_PROJECT:-'Não configurado'}"
            echo "   Location: ${GOOGLE_CLOUD_LOCATION}"
        else
            echo "Vertex AI: Desabilitado"
        fi
        
        # Verificar modelo
        echo "Modelo: $GEMINI_MODEL"
        echo "Temperatura: $GEMINI_TEMPERATURE"
        echo "Tema: $GEMINI_CLI_THEME"
        echo "Log Level: $GEMINI_CLI_LOG_LEVEL"
        
        # Verificar diretórios
        echo "Config Dir: $GEMINI_CLI_CONFIG_DIR"
        echo "Cache Dir: $GEMINI_CLI_CACHE_DIR"
        echo "Workspace: $GEMINI_CLI_WORKSPACE"
        
        echo "================================================================================"
    }
    
    # Função para configurar API Key interativamente
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
    
    # Função para configurar Vertex AI
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
    
    # Função para limpar cache
    function gemini-clear-cache() {
        if [[ -d "$GEMINI_CLI_CACHE_DIR" ]]; then
            rm -rf "$GEMINI_CLI_CACHE_DIR"/*
            echo "Cache limpo com sucesso!"
        else
            echo "Cache não encontrado"
        fi
    }
    
    # Função para criar diretórios necessários
    function gemini-init-dirs() {
        mkdir -p "$GEMINI_CLI_CONFIG_DIR"
        mkdir -p "$GEMINI_CLI_CACHE_DIR"
        mkdir -p "$GEMINI_CLI_LOG_DIR"
        mkdir -p "$GEMINI_CLI_WORKSPACE"
        echo "Diretórios criados com sucesso!"
    }
    
    # ===============================================================================
    # INICIALIZAÇÃO AUTOMÁTICA
    # ===============================================================================
    
    # Criar diretórios necessários se não existirem
    gemini-init-dirs 2>/dev/null
    
    # Verificar se há comandos gemini disponíveis
    if command -v gemini &> /dev/null; then
        echo "Gemini CLI detectado - Configurações carregadas"
    else
        echo "Gemini CLI não detectado - Instale com: npm install -g @google-ai/gemini-cli"
    fi
    
    # ===============================================================================
    # CONFIGURAÇÕES ESPECÍFICAS PARA DESENVOLVIMENTO PYTHON
    # ===============================================================================
    
    # Integração com ambiente Python
    export GEMINI_CLI_PYTHON_ENV="${VIRTUAL_ENV:-}"
    
    # Configurações para uso com uv
    if command -v uv &> /dev/null; then
        export GEMINI_CLI_UV_INTEGRATION="true"
        alias gemini-uv='uv run gemini'
    fi
    
    # Configurações para FastAPI
    export GEMINI_CLI_FASTAPI_TEMPLATE="${GEMINI_CLI_FASTAPI_TEMPLATE:-true}"
    
    echo "Configuração do Google Gemini CLI carregada com sucesso!"

fi

# ===============================================================================
# INFORMAÇÕES DE AJUDA
# ===============================================================================
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
  gemini-init-dirs        - Criar diretórios
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

# ===============================================================================
# FIM DO SCRIPT
# ===============================================================================