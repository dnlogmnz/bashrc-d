#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/node-functions.sh
# Funções para facilitar o uso do Node.js
# ==========================================================================================

#-------------------------------------------------------------------------------------------
# Função para limpar PATH do Node.js anterior
#-------------------------------------------------------------------------------------------
_clean_node_path() {
    # Remove todas as entradas relacionadas ao Node.js do PATH
    PATH=$(echo "$PATH" | tr ':' '\n' | grep -v "$NODE_HOME" | tr '\n' ':')
    # Remove ':' duplos e o último ':'
    PATH=$(echo "$PATH" | sed 's/::/:/g' | sed 's/:$//')
    export PATH
}


#-------------------------------------------------------------------------------------------
# Função para detectar se symlinks reais funcionam no Windows
#-------------------------------------------------------------------------------------------
_test_node_symlinks_support() {
    local test_dir=$(mktemp -d)
    local test_source="$test_dir/source"
    local test_link="$test_dir/link"

    mkdir -p "$test_source"
    echo "test" > "$test_source/test.txt"

    # Tentar criar symlink
    if ln -sf "$test_source" "$test_link" 2>/dev/null; then
        # Verificar se é symlink real (não cópia)
        if [ -L "$test_link" ]; then
            rm -rf "$test_dir"
            return 0  # Symlinks reais funcionam
        fi
    fi

    rm -rf "$test_dir"
    return 1  # Symlinks não funcionam (só cópias)
}


#-------------------------------------------------------------------------------------------
# Função para obter a versão atualmente ativa
#-------------------------------------------------------------------------------------------
_get_current_node_version() {
    local current_version=""

    # Verificar se existe versão padrão definida
    if [ -f "$NODE_HOME/.default_version" ]; then
        current_version=$(cat "$NODE_HOME/.default_version")
    fi

    # Verificar se o diretório current existe e se corresponde à versão padrão
    if [ -d "$NODE_CURRENT" ] && [ -n "$current_version" ]; then
        local node_dir="${NODE_HOME}/${current_version}"
        if [ -L "$NODE_CURRENT" ]; then
            # É um symlink - verificar destino
            if [ "$(readlink "$NODE_CURRENT")" = "$node_dir" ]; then
                echo "$current_version"
            fi
        elif [ -d "$node_dir" ]; then
            # É uma cópia - assumir que corresponde à versão padrão
            echo "$current_version"
        fi
    fi
}


#-------------------------------------------------------------------------------------------
# Função interna para listar versões instaladas com indicadores
#-------------------------------------------------------------------------------------------
_list_node_versions() {
    local show_header="${1:-true}"

    if [ "$show_header" = "true" ]; then
        echo "Versoes disponiveis:"
    fi

    if [ ! -d "$NODE_HOME" ]; then
        echo "  Nenhuma versao encontrada em $NODE_HOME"
        return 1
    fi

    local current_version=$(_get_current_node_version)
    local has_versions="false"

    # Listar diretórios que começam com "node-" e destacar a versão ativa
    while read -r version; do
        has_versions="true"
        if [ "$current_version" = "$version" ]; then
            echo "  $version (*)"
        else
            echo "  $version"
        fi
    done < <(ls -1 "$NODE_HOME" | grep "^node-" | tr -d '/')

    # Verificar se encontrou alguma versão
    if [ "$has_versions" = "false" ]; then
        echo "  Nenhuma versao encontrada em $NODE_HOME"
    fi
}


#-------------------------------------------------------------------------------------------
# Função para carregar versão padrão salva
#-------------------------------------------------------------------------------------------
_load_default_node() {
    if [ -f "$NODE_HOME/.default_version" ]; then
        local default_version=$(cat "$NODE_HOME/.default_version")
        local node_dir="${NODE_HOME}/${default_version}"

        if [ -d "$node_dir" ]; then
            # Limpar PATH anterior do Node.js
            _clean_node_path

            # Remover diretório/link atual
            if [ -e "$NODE_CURRENT" ]; then
                rm -rf "$NODE_CURRENT"
            fi

            # Criar link/cópia para versão padrão
            if _test_node_symlinks_support && ln -sf "$node_dir" "$NODE_CURRENT" 2>/dev/null; then
                # Symlink funcionou
                export PATH="$NODE_CURRENT:$PATH"
            else
                # Fallback: cópia
                cp -r "$node_dir" "$NODE_CURRENT"
                export PATH="$NODE_CURRENT:$PATH"
            fi
        fi
    fi
}


#-------------------------------------------------------------------------------------------
# Função para mostrar informações do Node.js
#-------------------------------------------------------------------------------------------
node-info() {
    echo "=== Informacoes do Node.js ==="
    echo "  Versao do Node ........: $(node --version 2>/dev/null || echo 'Node.js nao encontrado')"
    echo "  Versao do NPM .........: $(npm --version 2>/dev/null || echo 'NPM nao encontrado')"
    echo "  Executavel Node .......: $(which node 2>/dev/null || echo 'Nao encontrado')"
    echo "  Executavel NPM ........: $(which npm 2>/dev/null || echo 'Nao encontrado')"
    echo "  Diretorio atual .......: $NODE_CURRENT"
    echo "  Cache NPM .............: $NPM_CONFIG_CACHE"
    echo "  Pacotes globais .......: $NPM_CONFIG_PREFIX"
    echo "  Symlinks reais ........: $(_test_node_symlinks_support && echo "Sim (Developer Mode)" || echo "Nao (usando copia)")"

    # Mostrar versão padrão
    if [ -f "$NODE_HOME/.default_version" ]; then
        echo "  Versao padrao .........: $(cat "$NODE_HOME/.default_version")"
    else
        echo "  Versao padrao .........: Nenhuma definida"
    fi

    echo ""
    echo "=== Versoes instaladas ==="
    _list_node_versions false
}


#-------------------------------------------------------------------------------------------
# Função para exibir qual versão do Node.js está ativa
#-------------------------------------------------------------------------------------------
node-current() {
    if command -v node >/dev/null 2>&1; then
        echo "Versao ativa do Node.js: $(node --version)"
        echo "Caminho do executavel: $(which node)"
        if [ -f "$NODE_HOME/.default_version" ]; then
            echo "Versao padrao: $(cat "$NODE_HOME/.default_version")"
        else
            echo "Nenhuma versao padrao definida"
        fi
    else
        echo "ERRO: Node.js nao esta disponivel no PATH"
        echo "Execute: node-use <versao>"
        echo ""
        _list_node_versions true
    fi
}


#-------------------------------------------------------------------------------------------
# Função para alternar entre versões do Node.js (salva automaticamente como padrão)
#-------------------------------------------------------------------------------------------
node-use() {
    if [ -z "$1" ]; then
        echo "Uso: node-use <versao>"
        _list_node_versions true
        return 1
    fi

    local version="$1"
    local node_dir="${NODE_HOME}/${version}"

    if [ ! -d "$node_dir" ]; then
        echo "Node.js versao $version nao encontrada"
        echo "Diretorio esperado: $node_dir"
        echo ""
        _list_node_versions true
        return 1
    fi

    echo "Alterando para Node.js versao $version..."

    # Limpar PATH anterior do Node.js
    _clean_node_path

    # Remover diretório/link atual completamente
    if [ -e "$NODE_CURRENT" ]; then
        echo "  Removendo versao anterior: $NODE_CURRENT"
        rm -rf "$NODE_CURRENT"
    fi

    # Tentar criar link simbólico primeiro
    if _test_node_symlinks_support && ln -sf "$node_dir" "$NODE_CURRENT" 2>/dev/null; then
        echo "  Criado symlink: $NODE_CURRENT -> $node_dir"
        method="symlink"
    else
        # Fallback para Windows: usar cópia completa
        echo "  Copiando arquivos (symlinks nao suportados)..."
        cp -r "$node_dir" "$NODE_CURRENT"
        method="copia"
    fi

    # Adicionar novo caminho do Node.js ao PATH
    export PATH="$NODE_CURRENT:$PATH"

    # Salvar como versão padrão automaticamente
    mkdir -p "$NODE_HOME"
    echo "$version" > "$NODE_HOME/.default_version"

    # Verificar se a mudança funcionou
    local active_version=$(node --version 2>/dev/null)
    local expected_version=$(grep -o 'v[0-9.]*' <<< "$version" || echo "desconhecida")

    if [ "$active_version" = "$expected_version" ] || [[ "$active_version" == *"$(echo $version | grep -o '[0-9.]*')"* ]]; then
        echo "OK Node.js versao $version ativada com sucesso (via $method)"
        echo "   Versao ativa: $active_version"
        echo "   Salva como padrao para proximas sessoes"
    else
        echo "ERRO: Versao nao foi ativada corretamente"
        echo "   Esperado: $expected_version"
        echo "   Atual: $active_version"
        echo "   Caminho do executavel: $(which node)"
        echo ""
        echo "Depuracao:"
        echo "   NODE_CURRENT: $NODE_CURRENT"
        echo "   PATH: $PATH"
        return 1
    fi
}


#-------------------------------------------------------------------------------------------
# Função para exibir instruções para instalar uma nova versão do Node.js
#-------------------------------------------------------------------------------------------
node-download() {
    if [ -z "$1" ]; then
        echo "Uso: node-download <versao>"
        echo "Exemplo: node-download 18.17.0"
        echo ""
        _list_node_versions true
        return 1
    fi

    local version="$1"
    local node_dir="${NODE_HOME}/node-v${version}-win-x64"

    if [ -d "$node_dir" ]; then
        echo "Node.js versao $version ja esta instalada em:"
        echo "  $node_dir"
        echo "Para usar: node-use node-v${version}-win-x64"
        echo ""
        _list_node_versions true
        return 0
    fi

    echo "Para instalar Node.js $version:"
    echo "1. Baixe de: https://nodejs.org/dist/v${version}/node-v${version}-win-x64.zip"
    echo "2. Extraia para: $node_dir"
    echo "3. Execute: node-use node-v${version}-win-x64"
    echo ""
    echo "=== Versoes ja instaladas ==="
    _list_node_versions false
}


#-------------------------------------------------------------------------------------------
# Função para listar projetos Node.js
#-------------------------------------------------------------------------------------------
node-projects() {
    echo "=== Projetos Node.js no diretorio atual ==="
    local found_projects=false

    find . -name "package.json" | head -10 | while read project; do
        found_projects=true
        echo "  $project"
    done

    if [ "$found_projects" = "false" ]; then
        echo "  Nenhum projeto Node.js encontrado no diretorio atual"
    fi
}


#-------------------------------------------------------------------------------------------
# Função para criar projeto Node.js básico
#-------------------------------------------------------------------------------------------
node-new-project() {
    local project_name="${1:-$(basename $PWD)}"

    if [ -f package.json ]; then
        echo "package.json ja existe no diretorio atual"
        return 1
    fi

    echo "Criando projeto Node.js: $project_name"

    # Verificar se Node.js está disponível
    if ! command -v node >/dev/null 2>&1; then
        echo "ERRO: Node.js nao encontrado. Execute primeiro:"
        echo "   node-use <versao>"
        echo ""
        _list_node_versions true
        return 1
    fi

    echo "Versao do Node.js: $(node --version)"
    npm init -y

    echo "OK Projeto criado com sucesso!"
    echo "Comandos uteis:"
    echo "  npm install <pacote>     - Instalar dependencia"
    echo "  npm install -D <pacote>  - Instalar dev dependency"
    echo "  npm run <script>         - Executar script"
    echo "  npm test                 - Executar testes"
}


#-------------------------------------------------------------------------------------------
# Função para limpar cache do NPM
#-------------------------------------------------------------------------------------------
npm-clean() {
    echo "Limpando cache do NPM..."
    if command -v npm >/dev/null 2>&1; then
        npm cache clean --force
        echo "Cache limpo!"
    else
        echo "ERRO: NPM nao encontrado. Execute primeiro: node-use <versao>"
        echo ""
        _list_node_versions true
    fi
}


#-------------------------------------------------------------------------------------------
# Função para verificar pacotes desatualizados
#-------------------------------------------------------------------------------------------
npm-outdated() {
    echo "Verificando pacotes desatualizados..."
    if command -v npm >/dev/null 2>&1; then
        npm outdated
    else
        echo "ERRO: NPM nao encontrado. Execute primeiro: node-use <versao>"
        echo ""
        _list_node_versions true
    fi
}


#-------------------------------------------------------------------------------------------
# Função para audit de segurança
#-------------------------------------------------------------------------------------------
npm-audit() {
    echo "Executando audit de seguranca..."
    if command -v npm >/dev/null 2>&1; then
        npm audit
        echo ""
        echo "Para corrigir vulnerabilidades automaticamente:"
        echo "  npm audit fix"
    else
        echo "ERRO: NPM nao encontrado. Execute primeiro: node-use <versao>"
        echo ""
        _list_node_versions true
    fi
}


#-------------------------------------------------------------------------------------------
# Carregar versão padrão automaticamente quando o script é inicializado
#-------------------------------------------------------------------------------------------
_load_default_node 2>/dev/null


#-------------------------------------------------------------------------------------------
#--- Final do script 'node-functions.sh'
#-------------------------------------------------------------------------------------------