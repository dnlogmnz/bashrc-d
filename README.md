## Project bashrc-d
Run Command (rc) scripts for Git Bash for Windows.  

These scripts will set environment variabels for several DevSecOps tools.  

## Project Gidelines

### Git Commit Guidelines  
Commit messages for this project follows [EU System | Git Commit Guidelines](!https://ec.europa.eu/component-library/v1.15.0/eu/docs/conventions/git/) conventions.


## Installation instructions

### 1. General instructions  

This doc assumes that you will install all sofwares without administrative privileges in Windows.


### 2. Configure your HOME directory  

- Create a directory D:\%USERNAME%\home
- Click the Windows Key ant type "Edit environment variables for your account"
- Add a new variable "HOME" with "D:\%USERNAME%\home"


### 3. Git for Windows  

- Create a directory D:\%USERNAME%\Apps\Git
- Open https://git-scm.com/downloads/win
- Download the "Standalone Installer" / "Git for Windows/x64 Setup".
- Execute "Git-<version>-64-bit.exe"
- Install to D:\%USERNAME%\Apps\Git


### 4. Clone this project files - `bashrc-d`
- Open Git Bash and execute this: 
| Bash
| # Create a folder for projects
| mkdir -p /d/$USERNAME/projects
| cd /d/$USERNAME/projects
| 
| # Clone this repository
| git clone https://github.com/dnlogmnz/bashrc-d.git

- Close Git Bash and reopen it. 


### 5. Node.js

- Create a directory D:\%USERNAME%\Apps\node
- Execute `node-install` and follow instructions

### 6. Astral uv package and project manager

- Read https://docs.astral.sh/uv/#installation
- Open Git Bash and execute this: 
| Bash
| # Create a directory D:\%USERNAME%\Apps\uv
| mkdir -p /d/$USERNAME/Apps/uv
| cd /d/$USERNAME/Apps/uv
| 
| # Install uv
| curl -LsSf https://astral.sh/uv/install.sh | sh


### 7. Python - managed by uv


### 8. Podman Remote CLI and Podman Desktop
| - Download installer from https://podman-desktop.io/downloads/windows
| - Execute:
| ```
| Bash
| #!/bin/bash
| # Scrit: Podman: create folders and place executables for Podman CLI and Podman Desktop
| 
| PODMAN_RELEASE="1.20.2"
| APPS_BASE="/d/$USERNAME/Apps"
| PODMAN_CLI_DIR="$APPS_BASE/Podman/podman"
| PODMAN_DESKTOP_DIR="$APPS_BASE/Podman/Podman Desktop"
| PODMAN_INSTALLERS_DIR="/d/Install"  # or use the Windows default download dir: "$HOME/Downloads"
| 
| mkdir -p "$PODMAN_CLI_DIR"
| mkdir -p "$PODMAN_DESKTOP_DIR"
| 
| # Unzip the Podman Remote CLI
| unzip "$PODMAN_INSTALLERS_DIR/podman-remote-release-windows_amd64.zip" -d "$PODMAN_CLI_DIR/"
| 
| # Copy the Podman Desktop executable
| cp -v "$PODMAN_INSTALLERS_DIR/podman-desktop-${PODMAN_RELEASE}-x64.exe" "$PODMAN_DESKTOP_DIR/"
| ```
