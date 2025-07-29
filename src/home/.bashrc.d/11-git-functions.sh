#!/bin/bash
# ==========================================================================================
# Script: ~/.bashrc.d/git-functions.sh
# Funções para facilitar o uso do Git CLI
# ==========================================================================================

#-------------------------------------------------------------------------------------------
# Função para mostrar informações do Git
#-------------------------------------------------------------------------------------------
git-info() {
    echo "=== Informações do Git ==="
    echo "  Versão ................: $(git --version 2>/dev/null || echo 'Git não encontrado')"
    echo "  Executável ............: $(which git 2>/dev/null || echo 'Não encontrado')"
    echo "  Global Config Name  ...: $(git config --global user.name 2>/dev/null || echo 'Não configurado')"
    echo "  Global Config Email ...: $(git config --global user.email 2>/dev/null || echo 'Não configurado')"
    echo "  Global Config Editor ..: $(git config --global core.editor 2>/dev/null || echo 'Não configurado')"

    if git rev-parse --git-dir &>/dev/null; then
        echo ""
        echo "=== Repositório do diretório corrente ==="
        echo "  Branch ................: $(git branch --show-current 2>/dev/null || echo 'Não disponível')"
        echo "  Status ................: $(git status --porcelain | wc -l) arquivos modificados"
        echo "  Remote ................: $(git remote get-url origin 2>/dev/null || echo 'Não configurado')"
    fi
}


#-------------------------------------------------------------------------------------------
# Função para configurar Git globalmente
#-------------------------------------------------------------------------------------------
git-config() {
    echo "Configurando Git..."
    read -p "Nome completo: " name
    read -p "Email: " email

    git config --global user.name "$name"
    git config --global user.email "$email"
    git config --global core.autocrlf false
    git config --global core.eol lf
    git config --global gui.encoding utf-8
    git config --global http.sslbackend schannel

    echo "Git configurado com sucesso!"
    git-info
}


#-------------------------------------------------------------------------------------------
# Função para status rápido da branch corrente
#-------------------------------------------------------------------------------------------
git-branch() {
    if ! git rev-parse --git-dir &>/dev/null; then
        echo "Não é um repositório Git"
        return 1
    fi

    echo "=== Remote Branches ==="
    git branch -vv -r
    echo ""
    echo "=== Local Branches ==="
    git branch -vv
    echo ""
    echo "=== Current Branch ==="
    echo "  Branch ................: $(git branch --show-current)"
    echo "  Arquivos modificados ..: $(git status --porcelain | wc -l)"
    echo "  Commits ahead .........: $(git rev-list --count HEAD @{upstream} 2>/dev/null || echo '0')"
    echo "  Commits behind ........: $(git rev-list --count @{upstream} HEAD 2>/dev/null || echo '0')"
}

#-------------------------------------------------------------------------------------------
#--- Final do script 'git-functions.sh'
#-------------------------------------------------------------------------------------------