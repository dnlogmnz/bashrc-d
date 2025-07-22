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
```Bash
# Create a folder for projects
mkdir -p /d/$USERNAME/projects
cd /d/$USERNAME/projects

# Clone this repository
git clone https://github.com/dnlogmnz/bashrc-d.git
```
- Close Git Bash and reopen it. 


### 5. Node.js

- Create a directory D:\%USERNAME%\Apps\node
- Execute `node-install` and follow instructions

### 6. Astral uv package and project manager

- Read https://docs.astral.sh/uv/#installation
- Open Git Bash and execute this: 
```Bash
# Create a directory D:\%USERNAME%\Apps\uv
mkdir -p /d/$USERNAME/Apps/uv
cd /d/$USERNAME/Apps/uv

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 7. Python - managed by uv
