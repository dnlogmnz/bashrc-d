#!/usr/bin/env bash
# =============================================================================
# Script: bashrc-d-install.sh (refactored)
# Backs up current "bashrc" related files and installs project scripts
# Refactored: main actions separated into local functions
# =============================================================================
set -euo pipefail

SOURCE_DIR="${HOME}/projetos/bashrc-d/src/home"
NOW="$(date '+%Y-%m-%d-%Hm%Mm')"
BACKUP_DIR="${HOME}/backup/${NOW}"

# Prepare backup destination directory
prepare_backup_dir() {
    local now
    echo ""
    echo "=== Validate backup directory ==="
    now="$(date '+%Y-%m-%d-%Hm%Mm')"
    BACKUP_DIR="${HOME}/backup/${now}"

    if [ -d "${BACKUP_DIR}" ]; then
        while [ "$(date '+%Y-%m-%d-%Hm%Mm')" = "${now}" ]; do
            echo " - [$(date \"+%Hm%Mm%Ss\")] Directory '${now}' already exists, waiting for the next minute..."
            sleep 5
        done
    fi

    NOW="$(date '+%Y-%m-%d-%Hm%Mm')"
    BACKUP_DIR="${HOME}/backup/${NOW}"
    echo " - [$(date \"+%Hm%Mm%Ss\")] Backup destination: ${BACKUP_DIR}"
}

# Backup current "bashrc" related files in $HOME
backup_current_scripts() {
    echo ""
    echo "=== Backup current scripts ==="
    mkdir -p "${BACKUP_DIR}"

    local files=( ".bashrc" ".bashrc.d" ".bash_profile" )
    for f in "${files[@]}"; do
        if [ -e "${HOME}/${f}" ]; then
            echo " - [$(date \"+%Hm%Mm%Ss\")] Moving ${HOME}/${f} -> ${BACKUP_DIR}/"
            mv -v -i "${HOME}/${f}" "${BACKUP_DIR}"
        else
            echo " - [$(date \"+%Hm%Mm%Ss\")] Not found: ${HOME}/${f} (skipping)"
        fi
    done
}

# Copy project files to $HOME
copy_project_files() {
    echo ""
    echo "=== Copy project scripts to '\$HOME' ==="

    local source_count
    source_count=$(ls "${SOURCE_DIR}/.bashrc.d/"*.sh 2>/dev/null | wc -l || true)
    echo " - Source scripts ......: ${source_count} scripts in ${SOURCE_DIR}/.bashrc.d/"

    local items=( ".bashrc" ".bashrc.d" ".bash_profile" )
    for it in "${items[@]}"; do
        if [ -e "${SOURCE_DIR}/${it}" ]; then
            echo " - [$(date \"+%Hm%Mm%Ss\")] Copying: ${SOURCE_DIR}/${it} -> ${HOME}/"
            cp -irp "${SOURCE_DIR}/${it}" "${HOME}/"
        else
            echo " - [$(date \"+%Hm%Mm%Ss\")] Source not present: ${SOURCE_DIR}/${it} (skipping)"
        fi
    done
}

# As a test, source a script that contains useful bash functions
load_test_script() {
    local test_script="${SOURCE_DIR}/.bashrc.d/00-bash-functions.sh"
    if [ -f "${test_script}" ]; then
        # shellcheck source=/dev/null
        source "${test_script}"
        echo " - [$(date \"+%Hm%Mm%Ss\")] Loaded helper functions script: ${test_script}"
    else
        echo " - [$(date \"+%Hm%Mm%Ss\")] Helper functions script not found: ${test_script} (skipping)"
    fi
}

# Show count of copied files
show_counts() {
    local bashrc_count
    bashrc_count=$(ls "${HOME}/.bashrc.d/"*.sh 2>/dev/null | wc -l || true)
    echo " - Copied scripts ......: ${bashrc_count} scripts copied to ${HOME}/.bashrc.d"
}

# Show installation verdict
show_verdict() {
    if declare -F "displayInfo" > /dev/null; then
        echo ""
        displayTitle "Installation completed successfully!" 2>/dev/null || true
        displayInfo "You should close this shell and open a new one for changes to take effect." || true
    else
        echo ""
        echo "Installation may have encountered an issue."
        echo "Check the output above, or try copying files manually."
        echo ""
    fi
}

# Unset environment variables used by this script
cleanup_vars() {
    unset NOW SOURCE_DIR BACKUP_DIR
    unset SOURCE_COUNT BASHRC_COUNT FUNC_TYPE INSTALL_DIR || true
}

main() {
    prepare_backup_dir
    backup_current_scripts
    copy_project_files
    load_test_script
    show_counts
    show_verdict
    cleanup_vars
}

# Execute
main "$@"

#--------------------------------------------------------------------------------
#--- End of 'bashrc-d-install.sh' (refactored)
#--------------------------------------------------------------------------------
