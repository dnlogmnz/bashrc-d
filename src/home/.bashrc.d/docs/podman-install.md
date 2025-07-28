
# 🧊 Podman Remote CLI and Podman Desktop Setup (No Admin Rights)

This guide walks you through installing **Podman Remote CLI** and **Podman Desktop** on Windows without requiring administrator privileges. It includes a Bash script to automate folder creation and file placement, plus manual steps for verification and usage.

---

## 🗂️ Step 0: (Optional) Change Windows Default Save Location to D:\

If you have a `D:` drive, move your personal Windows folders to it:

1. Open Windows Settings: press `Windows key` + `I`, or click the Start button and select the gear icon.  
2. Go to `System` → `Storage` → `Advanced storage settings`.  
3. Select `Where new content is saved`.  
4. Change all destinations to `D:`.  

This will create a folder: `D:\%USERNAME%`.  
  
Now, you may also create `D:\%USERNAME%\Apps` to store your applications.  

---

## 🗃️ Step 1: Create Folders for Installers and Podman Executables

- **Create a folder for installers**  
  1. Open Windows Explorer.  
  2. If you have a `D:` drive, create `D:\Installers`.  
  3. Otherwise, create **C:\Installers**.  

- **About Step 0 and folders**  
  - If using `D:`, assume that `%APPS_BASE%` is `D:\%USERNAME%\Apps`.  
  - Otherwise, assume it as **%LOCALAPPDATA%\Programs**.  
  - Note: **%LOCALAPPDATA%** points to **C:\Users\%USERNAME%\AppData\Local**  

- **Create the folders for Podman executables**  
  1. `%APPS_BASE%\Podman`  
  2. `%APPS_BASE%\Podman\podman`  
  3. `%APPS_BASE%\Podman\Podman Desktop`  

---

## 📥 Step 2: Download Podman Components

- **Podman Desktop Installer**  
  1. Visit [Podman Windows Downloads](https://podman-desktop.io/downloads/windows).  
  2. Download the **Portable binary**.  
  3. Save it to `%INSTALLERS_DIR%`.  

- **Podman Remote CLI (Portable ZIP)**  
  1. Visit [Podman GitHub Releases](https://github.com/containers/podman/releases).  
  2. ***Note***: the first release on this page usually is a Release Candidate (RC).  
  3. Scroll down and look for the version marked `Latest`.  
  4. Under **Assets**, download the file named like `podman-vX.Y.Z-win-x64.zip`.  
  5. Save it to `%INSTALLERS_DIR%`.  

---

## 🛠️ Step 3: Manually Install Podman Remote CLI and Podman Desktop

Use the following Bash script to automate folder setup and file placement:

```bash
#!/bin/bash

# Folder for Installers
if [ -d "/d/Install" ]
  then "$INSTALLERS_DIR"="/d/Install"
  else "$INSTALLERS_DIR"="/c/Users/${USERNAME}/Downloads"
fi
mkdir -p "$INSTALLERS_DIR"

# Folder for Executables
if [ -d "/d/${USERNAME}/Apps" ]
  then "$APPS_BASE"="/d/${USERNAME}/Apps"
  else "$APPS_BASE"="/c/Users/${USERNAME}/AppData/Local/Programs"
fi
mkdir -p "$APPS_BASE"

# Podman Remote CLI
PODMAN_CLI_VERSION="5.5.2"
PODMAN_CLI_DIR="$APPS_BASE/Podman/podman"
mkdir -p "$PODMAN_DESKTOP_DIR"
unzip \
  "$INSTALLERS_DIR/podman-remote-release-windows_amd64.zip" \
  -d "$PODMAN_CLI_DIR/"

# Podman Desktop for Windows
PODMAN_DESKTOP_RELEASE="1.20.2"
PODMAN_DESKTOP_DIR="$APPS_BASE/Podman/Podman Desktop"
mkdir -p "$PODMAN_CLI_DIR"
cp -v \
  "$INSTALLERS_DIR/podman-desktop-${PODMAN_DESKTOP_RELEASE}-x64.exe" \
  "$PODMAN_DESKTOP_DIR/"
```

After extracting Podman Remote CLI as above, you should be able to run:

```bash
export PATH=$PODMAN_CLI_DIR/podman-${PODMAN_CLI_VERSION}/usr/bin:$PATH
podman --version
```

---

## 🚀 Step 4: Initialize and Start the Podman Machine

1. Open a new Git Bash terminal.  
2. Run this command once to initialize the Podman machine:

```bash
podman machine init
```

This downloads a lightweight Fedora image and sets up a VM using WSL.

3. Start the Podman machine whenever you're ready to use containers:

```bash
podman machine start
```

---

## 🔍 Step 5: Verify Installation

Run the following to confirm Podman is working:

```bash
echo "=== Podman Info ==="
podman version

echo ""
echo "=== Podman Machines ==="
podman machine list
```

---

## 🧪 Step 6: Run a Test Container

To test your setup:

```bash
podman run --rm hello-world
```

If this command runs successfully, Podman is correctly installed and ready to integrate with your WSL environment - without needing admin rights.

---
