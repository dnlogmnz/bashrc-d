#!/bin/bash
# =========================================================================================
# Arquivo: node-functions.sh
# Funções para facilitar o uso do Node.js
# =========================================================================================

#------------------------------------------------------------------------------------------
# Função para mostrar informações do Node.js
#------------------------------------------------------------------------------------------
node-info() {
    echo "=== Informações do Node.js ==="
    echo "Versão do Node: $(node --version 2>/dev/null || echo 'Node.js não encontrado')"
    echo "Versão do NPM: $(npm --version 2>/dev/null || echo 'NPM não encontrado')"
    echo "Executável Node: $(which node 2>/dev/null || echo 'Não encontrado')"
    echo "Executável NPM: $(which npm 2>/dev/null || echo 'Não encontrado')"
    echo "Diretório atual: $NODE_CURRENT"
    echo "Cache NPM: $NPM_CONFIG_CACHE"
    echo "Pacotes globais: $NPM_CONFIG_PREFIX"
    echo ""
    echo "=== Versões instaladas ==="
    if [ -d "$NODE_HOME" ]; then
        ls -la "$NODE_HOME" | grep "^d" | grep -v "^\." | awk '{print $9}' | grep -E "^node-"
    fi
}


#------------------------------------------------------------------------------------------
# Função para alternar entre versões do Node.js
#------------------------------------------------------------------------------------------
node-use() {
    if [ -z "$1" ]; then
        echo "Uso: node-use <versão>"
        echo "Versões disponíveis:"
        if [ -d "$NODE_HOME" ]; then
            ls -l $NODE_HOME | grep "^d" | tr -d '/' | awk '{print $9}' | grep -E "^node-"
        fi
        return 1
    fi
    
    local version="$1"
    local node_dir="${NODE_HOME}/${version}"
    
    if [ ! -d "$node_dir" ]; then
        echo "Node.js versão $version não encontrada"
        echo "Diretório esperado: $node_dir"
        return 1
    fi
    
    # Remover link simbólico atual
    if [ -L "$NODE_CURRENT" ]; then
        rm "$NODE_CURRENT"
    fi
    
    # Criar novo link simbólico (no Windows, usar cópia se link não funcionar)
    if ln -s "$node_dir" "$NODE_CURRENT" 2>/dev/null; then
        echo "Node.js versão $version ativada via link simbólico"
    else
        # Fallback para Windows: usar cópia
        cp -r "$node_dir" "$NODE_CURRENT"
        echo "Node.js versão $version ativada (via cópia)"
    fi
    
    # Recarregar PATH
    export PATH="$NODE_CURRENT:$PATH"
    
    echo "Node.js versão ativa: $(node --version)"
}


#------------------------------------------------------------------------------------------
# Função para exibir instruções para instalar uma nova versão do Node.js
#------------------------------------------------------------------------------------------
node-install() {
    if [ -z "$1" ]; then
        echo "Uso: node-install <versão>"
        echo "Exemplo: node-install 18.17.0"
        return 1
    fi
    
    local version="$1"
    local node_dir="${NODE_HOME}/node-${version}"
    
    if [ -d "$node_dir" ]; then
        echo "Node.js versão $version já está instalada"
        return 0
    fi
    
    echo "Para instalar Node.js $version:"
    echo "1. Baixe de: https://nodejs.org/dist/v${version}/node-v${version}-win-x64.zip"
    echo "2. Extraia para: $node_dir"
    echo "3. Execute: node-use $version"
}


#------------------------------------------------------------------------------------------
# Função para listar projetos Node.js
#------------------------------------------------------------------------------------------
node-projects() {
    echo "=== Projetos Node.js no diretório atual ==="
    find . -name "package.json" | head -10
}


#------------------------------------------------------------------------------------------
# Função para criar projeto Node.js básico
#------------------------------------------------------------------------------------------
node-init() {
    if [ -f package.json ]; then
        echo "package.json já existe no diretório atual"
        return 1
    fi
    
    echo "Criando projeto Node.js..."
    npm init -y
    
    echo "Projeto criado com sucesso!"
    echo "Comandos úteis:"
    echo "  npm install <pacote>     - Instalar dependência"
    echo "  npm install -D <pacote>  - Instalar dev dependency"
    echo "  npm run <script>         - Executar script"
    echo "  npm test                 - Executar testes"
}


#------------------------------------------------------------------------------------------
# Função para limpar cache do NPM
#------------------------------------------------------------------------------------------
npm-clean() {
    echo "Limpando cache do NPM..."
    npm cache clean --force
    echo "Cache limpo!"
}


#------------------------------------------------------------------------------------------
# Função para verificar pacotes desatualizados
#------------------------------------------------------------------------------------------
npm-outdated() {
    echo "Verificando pacotes desatualizados..."
    npm outdated
}


#------------------------------------------------------------------------------------------
# Função para audit de segurança
#------------------------------------------------------------------------------------------
npm-audit() {
    echo "Executando audit de segurança..."
    npm audit
    echo ""
    echo "Para corrigir vulnerabilidades automaticamente:"
    echo "  npm audit fix"
}

#------------------------------------------------------------------------------------------
#--- Final do script
#------------------------------------------------------------------------------------------