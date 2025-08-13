# Project bashrc-d
Run Command (rc) scripts for Git Bash for Windows.  

## Objetivo

Instaladores de aplicativos para Windows normalmente usam como destino de instalação diretórios tais como `%LOCALAPPDATA%\Programs`, ou `%USERPROFILE%\.local`
Em muitos ambientes corporativos, esse caminho não está no PATH do sistema, ou a política de segurança pode restringir a execução de binários a partir do diretório do usuário.
 
Este repositório contém uma coleção de shell scripts criados para facilitar a personalização do ambiente Git Bash for Windows.
These scripts will set environment variabels for several DevSecOps tools.  

Principais caracteristicas:  
- Modularizar configurações e comandos do Bash, tornando o gerenciamento do ambiente mais organizado.
- Permitir adicionar, modificar ou remover funcionalidades do shell de forma simples e independente.


## Project Guidelines

### 1. Windows account without Administrative privilege  

For security reasons, several companies do not allow users to have administrative privileges on their computers.  

This project was created to comply with this restriction, and assumes that you will install all tools without administrative privileges in Windows.  

### 2. General instructions

Todas os scripts deste repositório, bem como os comandos mostrados neste documento foram testados em um Git Bash for Windows.  
- É provável que funcionem em outros "sabores" de `bash`, e mesmo em outros sistemas operacionais com ajustes mínimos.  
- Fique à vontade para testar!  

Os scripts deste repositório estão no diretório `src/home/.bashrc.d/`:
- Cada script executa configurações ou inicializações específicas, como variáveis de ambiente, aliases, funções e integrações com ferramentas de linha de comando.  
- Mantenha scripts pequenos e temáticos para facilitar manutenção.
- Organização dos scripts:
  - Por ferramenta: scripts para produtos tais como Git, Terraform, Python, Node.js, etc.  
  - Por finalidade: scripts para aliases (`<tool>-alias.sh`), variáveis de ambiente (`<tool>-envs.sh`) e shell functions (`<tool>-functions.sh`).  

As ferramentas devem estar instaladas em diretórios abaixo de `%APPS_BASE%`:  
- Explicação de APPS_BASE

Como instalar os scripts:
- Você deve criar um diretório `$HOME/.bashrc.d`, e copiar os scripts para esse local.
- Além disso, você deve incluir uma linha com a instrução `source` para que sejam carregados automaticamente pelo `$HOME/.bashrc` ao iniciar um novo terminal.


### 3. Git Commit Guidelines
Commit messages for this project follows [EU System | Git Commit Guidelines](https://ec.europa.eu/component-library/v1.15.0/eu/docs/conventions/git/) conventions.  


## Planned Directory Structure
```
C:\Users\%USERNAME%          # Windows %%USERPROFILE%
    +- AppData
    |  +- Local              # Windows %LOCALAPPDATA%
    |     +- Programs        # Default Windows location to install new apps and toole for the current user
    |  +- LocalLow
    |  +- Roaming            # Windows %APPDATA%
    +- ...                   # all other User Profile's directories (Desktop, Downloads, etc) and files

D:\%USERNAME%
    +- Apps                  # %APPS_BASE% directory
    |  +- Git
    |  |  +- tmp/            # mounting point for %TEMP% and %TMP% variables
    |  |  +- ...             # other Git's directories and files
    |  +- Nodejs
    |  |  +- current/        # must be in current users's PATH; it is a Symlink/Junction to one of the node versions below
    |  |  +- node-vAA.BB.C-win-x64/  # prebuilt Node.js standalone binary; extracted from a ZIP file
    |  |  +- node-vKK.LL.M-win-x64/  # prebuilt Node.js standalone binary; extracted from a ZIP file
    |  |  +- node-vXX.YY.Z-win-x64/  # prebuilt Node.js standalone binary; extracted from a ZIP file
    |  +- Python
    |  |  +- bin/            # python's shims created by 'uv' for the current Python version
    |  |  +- current/        # must be in current users's PATH; it is a Symlink/Junction to one of the python versions below
    |  |  +- cpython-3.AA.BB-windows-x86_64-none/  # uv managed python version
    |  |  +- cpython-3.KK.LL-windows-x86_64-none/  # uv managed python version
    |  |  +- python-3.XX.YY-amd64/                 # manually installed python version
    |  +- uv/                # uv's files and directories
    |  |  +- uv.toml         # UV_CONFIG_FILE 
    |  |  +- bin/            # UV_INSTALL_DIR
    |  |  +- cache/          # UV_CACHE_DIR
    |  |  +- tools/          # UV_TOOL_DIR      
    +- home
       +- .bash_history
       +- .bash_profile
       +- .bashrc
       +- .bashrc.d          # This project scripts' location  
```


## Installation instructions

### 1. Requisitos

- Git for Windows (includes Git Bash)


### 2. Configure "D:\%USERNAME%\home" as your HOME directory for Git Bash

- Using Windows Explorer or Command Prompt (cmd.exe), create a directory `D:\%USERNAME%\home`  

- Click the Windows Key and type "Edit environment variables for your account".  

- In "Environment user variabels for <your name>", click "New".
  - Variable Name: `HOME`  
  - Variable Value: `D:\%USERNAME%\home`  
  
- Click "Ok" to accept these settings, and the "Ok" again to close the application.  


### 3. Install Git for Windows

- Create a directory D:\%USERNAME%\Apps\Git  
- Open https://git-scm.com/downloads/win  
- Download the "Standalone Installer" / "Git for Windows/x64 Setup".  
- Execute "Git-<version>-64-bit.exe"  
- Install to D:\%USERNAME%\Apps\Git  


### 4. Clone this project files - `bashrc-d`
- Open Git Bash and execute this:  
```Bash
# Create a folder for projects
mkdir -p /d/$USERNAME/projects
cd /d/$USERNAME/projects

# Clone this repository
git clone https://github.com/dnlogmnz/bashrc-d.git
```
- Close Git Bash and reopen it. 

## Licença

Este repositório está licenciado sob os termos da licença MIT.

## Contribuições

Contribuições são bem-vindas! Sinta-se livre para enviar pull requests ou abrir issues para sugestões e melhorias.
