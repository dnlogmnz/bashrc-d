#!/bin/bash
# =============================================================================
# Script: bashrc-d-install.sh
# Faz backup dos scripts "bashrc" correntes, e instala os scripts do projeto
# =============================================================================
SOURCE_DIR="$HOME/projetos/bashrc-d/src/home"
NOW="$(date '+%Y-%m-%d-%Hm%Mm')"
BACKUP_DIR=$HOME/backup/$NOW

# Preparar diretório de destino do backup
echo ""
echo "=== Validar diretório de backup ==="
if [ -d "$BACKUP_DIR" ]; then
    while [ "$(date '+%Y-%m-%d-%Hm%Mm')" == "${NOW}" ]; do
        echo " - [$(date "+%Hm%Mm%Ss")] Diretório '$NOW' já existe, aguardando próximo minuto..."
        sleep 5
    done
fi
NOW="$(date '+%Y-%m-%d-%Hm%Mm')"
BACKUP_DIR=$HOME/backup/$NOW
echo " - [$(date "+%Hm%Mm%Ss")] Destino do backup: $BACKUP_DIR"

# Backup all current "bashrc" related files in $HOME
echo ""
echo "=== Backup dos scripts correntes ==="
mkdir -p $BACKUP_DIR
mv -v -i $HOME/.bash{rc,rc.d,_profile} $BACKUP_DIR

# Install all "bashrc-d" project files to $HOME
echo ""
echo "=== Cópia dos scripts do projeto para '\$HOME' ==="
SOURCE_COUNT=$(ls ${SOURCE_DIR}/.bashrc.d/*.sh | wc -l)
echo " - Scripts na origem ....: ${SOURCE_COUNT} scripts in ${SOURCE_DIR}/.bashrc.d/"

# Executa a cópia
cp -irp ${SOURCE_DIR}/.bash{rc,rc.d,_profile} $HOME

# Como teste, carrega script contendo funções úteis para o Bash
source ${SOURCE_DIR}/.bashrc.d/00-bash-functions.sh

# Apresenta a contagem de arquivos copiados
BASHRC_COUNT=$(ls ~/.bashrc.d/*.sh | wc -l)
echo " - Scripts copiados .....: $BASHRC_COUNT scripts copiados para $HOME/.bashrc.d"

# Apresenta veredito do processo de instalação
if declare -F "displayInfo" > /dev/null; then
    echo ""
    displayTitle "Instalação concluída com sucesso!" 2>/dev/null
    displayInfo "Você deve fechar este shell e abrir um novo para as alterações terem efeito."
else
    echo ""
    echo "Provavelmente ocorreu algum erro na instalação."
    echo "Verifique o resultado acima, ou tente fazer a cópia manualmente."
    echo ""
fi

# Libera variáveis de ambiente usadas neste script
unset NOW SOURCE_DIR SOURCE_COUNT INSTALL_DIR BASHRC_COUNT FUNC_TYPE

#--------------------------------------------------------------------------------
#--- Final do script 'bashrc-d-install.sh'
#--------------------------------------------------------------------------------