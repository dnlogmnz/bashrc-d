#!/bin/bash
# =========================================================================================
# Arquivo: gemini-cli-envs.sh
# Variaveis de ambiente para o Google Gemini CLI
# =========================================================================================

# Definir se deve carregar configurações (útil para debug)
export GEMINI_CLI_ENABLE_CONFIG=${GEMINI_CLI_ENABLE_CONFIG:-false}

if [[ "$GEMINI_CLI_ENABLE_CONFIG" == "true" ]]; then

    #---------------------------------------------------------------------------------
    # AUTENTICAÇÃO - API KEY (Método Principal)
    #---------------------------------------------------------------------------------

    # Chave da API do Gemini (obtida em https://ai.google.dev/gemini-api/docs/api-key)
    # Prioridade: GOOGLE_API_KEY > GEMINI_API_KEY
    export GOOGLE_API_KEY="${GOOGLE_API_KEY:-}"
    export GEMINI_API_KEY="${GEMINI_API_KEY:-}"

    #---------------------------------------------------------------------------------
    # AUTENTICAÇÃO - VERTEX AI (Para uso corporativo)
    #---------------------------------------------------------------------------------

    # Configurações para Vertex AI
    export GOOGLE_CLOUD_PROJECT="${GOOGLE_CLOUD_PROJECT:-}"
    export GOOGLE_CLOUD_LOCATION="${GOOGLE_CLOUD_LOCATION:-us-central1}"

    # Habilitar uso do Vertex AI
    export GOOGLE_GENAI_USE_VERTEXAI="${GOOGLE_GENAI_USE_VERTEXAI:-false}"

    # Credenciais do Google Cloud (JSON key file)
    export GOOGLE_APPLICATION_CREDENTIALS="${GOOGLE_APPLICATION_CREDENTIALS:-}"

    #---------------------------------------------------------------------------------
    # CONFIGURAÇÕES DE MODELO E COMPORTAMENTO
    #---------------------------------------------------------------------------------

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

    #---------------------------------------------------------------------------------
    # CONFIGURAÇÕES DE INTERFACE E TEMA
    #---------------------------------------------------------------------------------

    # Tema da interface (dark, light, auto)
    export GEMINI_CLI_THEME="${GEMINI_CLI_THEME:-auto}"

    # Idioma padrão
    export GEMINI_CLI_LANGUAGE="${GEMINI_CLI_LANGUAGE:-pt-BR}"

    # Habilitar cores no output
    export GEMINI_CLI_COLORS="${GEMINI_CLI_COLORS:-true}"

    # Habilitar markdown rendering
    export GEMINI_CLI_MARKDOWN="${GEMINI_CLI_MARKDOWN:-true}"

    #---------------------------------------------------------------------------------
    # CONFIGURAÇÕES DE LOGGING E DEBUG
    #---------------------------------------------------------------------------------

    # Nível de log (error, warn, info, debug)
    export GEMINI_CLI_LOG_LEVEL="${GEMINI_CLI_LOG_LEVEL:-info}"

    # Habilitar logging detalhado
    export GEMINI_CLI_VERBOSE="${GEMINI_CLI_VERBOSE:-false}"

    # Diretório para logs
    export GEMINI_CLI_LOG_DIR="${GEMINI_CLI_LOG_DIR:-$HOME/.gemini-cli/logs}"

    #---------------------------------------------------------------------------------
    # CONFIGURAÇÕES DE CACHE E PERFORMANCE
    #---------------------------------------------------------------------------------

    # Diretório de cache
    export GEMINI_CLI_CACHE_DIR="${GEMINI_CLI_CACHE_DIR:-$HOME/.gemini-cli/cache}"

    # Habilitar cache de respostas
    export GEMINI_CLI_CACHE_ENABLED="${GEMINI_CLI_CACHE_ENABLED:-true}"

    # Tempo de vida do cache (em segundos)
    export GEMINI_CLI_CACHE_TTL="${GEMINI_CLI_CACHE_TTL:-3600}"

    #---------------------------------------------------------------------------------
    # CONFIGURAÇÕES DE SEGURANÇA
    #---------------------------------------------------------------------------------

    # Timeout para requisições (em segundos)
    export GEMINI_CLI_TIMEOUT="${GEMINI_CLI_TIMEOUT:-30}"

    # Número máximo de tentativas
    export GEMINI_CLI_MAX_RETRIES="${GEMINI_CLI_MAX_RETRIES:-3}"

    # Habilitar verificação de certificados SSL
    export GEMINI_CLI_SSL_VERIFY="${GEMINI_CLI_SSL_VERIFY:-true}"

    #---------------------------------------------------------------------------------
    # CONFIGURAÇÕES DE PROJETO E CONTEXTO
    #---------------------------------------------------------------------------------

    # Diretório de configurações do usuário
    export GEMINI_CLI_CONFIG_DIR="${GEMINI_CLI_CONFIG_DIR:-$HOME/.gemini-cli}"

    # Arquivo de configurações personalizadas
    export GEMINI_CLI_CONFIG_FILE="${GEMINI_CLI_CONFIG_FILE:-$GEMINI_CLI_CONFIG_DIR/settings.json}"

    # Diretório de trabalho padrão
    export GEMINI_CLI_WORKSPACE="${GEMINI_CLI_WORKSPACE:-$HOME/workspace}"

    #---------------------------------------------------------------------------------
    # CONFIGURAÇÕES DE INTEGRAÇÃO COM FERRAMENTAS
    #---------------------------------------------------------------------------------

    # Habilitar integração com Git
    export GEMINI_CLI_GIT_INTEGRATION="${GEMINI_CLI_GIT_INTEGRATION:-true}"

    # Habilitar integração com VS Code
    export GEMINI_CLI_VSCODE_INTEGRATION="${GEMINI_CLI_VSCODE_INTEGRATION:-true}"

    # Editor padrão para comandos que requerem edição
    export GEMINI_CLI_EDITOR="${GEMINI_CLI_EDITOR:-${EDITOR:-nano}}"



    #---------------------------------------------------------------------------------
    # CONFIGURAÇÕES ESPECÍFICAS PARA DESENVOLVIMENTO PYTHON
    #---------------------------------------------------------------------------------

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

#------------------------------------------------------------------------------------------
#--- Final do script
#------------------------------------------------------------------------------------------