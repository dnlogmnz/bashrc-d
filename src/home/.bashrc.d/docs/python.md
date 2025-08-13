

## "uv" Commands and Variables

Here are some `uv` variables, commands, and `uv.toml` entries:

| Directory  | command             | environment variable  | uv.toml   |
| ---------- | ------------------- | --------------------- | :-------: |
| cache      | uv cache dir        | UV_CACHE_DIR          | cache-dir |
| Base installation directory for different versions of Python    | uv python dir       | UV_PYTHON_INSTALL_DIR | - |
| python bin | uv python dir --bin | UV_PYTHON_BIN_DIR     | - |
| tools      | uv tool dir         | UV_TOOL_DIR           | - |
| tools bin  | uv tool dir --bin   | UV_TOOL_BIN_DIR       | - |


## Python Installation Procedure

### Step 1: First installation (using Python's Oficial Installer)

1. Download the Installer:
- Go to the official Python downloads page: https://www.python.org/downloads/
- Click the button to download the latest version for Windows. You will get a file named something like "*python-3.X.X.exe*".

2. Run the Installer:
- Open the .exe file you downloaded.
- **This is the most important step:** on the first screen of the installer:
  - **Do NOT check** the box at the bottom that says "*Use admin provileges when installing py.exe*".
  - Check the box at the bottom that says "*Add python.exe to PATH*".
- Click "*Customize installation*" option. This ensures you can confirm it will install only for your user.

3. Customize the Installation:
- On the "*Optional Features*" screen:
  - You can leave the defaults checked, especially pip.
  - You may uncheck "*tcl/tk and IDLE*", if you are not going to create GUI apps with Tcl/Tk.
  - Click "Next".
- On the "*Advanced Options*" screen:
  - **Do NOT check** the box "*Install for all users.*"
  - In "C*ustomize install location*", points to custom Apps folder (e.g., D:\YourUsername\Apps\Python\Python313).
- Click "Install". The installation will proceed without any admin prompts.

4. Create the "*current*" SymLink or Junction:
- After the installation is completed, open a Command Prompt (`cmd.exe`).
- Create a Junction named `current`:
  ```cmd
  :: Go to the main Python installation directory
  cd /d D:\YourUsername\Apps\Python
  
  :: Suppose you have just installed Python 3.13
  mklink /J current Python313  
  ```
- You will see a message `Junction created for current <<===>> Python313`.
  - From now on, Windows will assume that `current` is your `Python 3.13` installation.


### Step 2: Adjusting Windows Enviroment Variables for Your Account

Agora vamos informar ao Windows e a todos os programas onde encontrar o Python "padrão".
1. No menu Iniciar, digite variáveis de ambiente e selecione "Editar as variáveis de ambiente para a sua conta".
2. Na seção "Variáveis de usuário para %USERNAME%", selecione a variável Path e clique em "Editar".
3. Procure as duas entradas do Python que você acabou de instalar, e troque por (nesta ordem):
   - D:\%USERNAME%\Apps\Python\current\Scripts
   - D:\%USERNAME%\Apps\Python\current
4. Clique em "OK" em todas as janelas para salvar.
5. Close all applications that use Python:
  - Git Bash (`bash.exe -i -l`).
  - Windows Command Prompt (`cmd.exe`).
  - All IDE's (Visual Studio Code, PyCharm, IDLE, etc).


### Step 3: Verify the Installation:
1. Open a new Git Bash (`bash.exe -i -l`) or a Windows Command Prompt (`cmd.exe`).
  - Type `python --version` and press Enter. You should see the version you just installed.
  - Type `pip --version` and press Enter.
2. Find out the path to the `python.exe` in your computer:
  - In a Git Bash, type `which python` and press Enter.
  - In a Command Prompt, type `where python` and press Enter.


## References

1. [PEP 397 – Python launcher for Windows](https://peps.python.org/pep-0397/)
- **Lançador Python para Windows**: O PEP 397 introduz o utilitário `py.exe`, um lançador que ajuda a localizar e executar diferentes versões do Python no Windows.
- **Gerenciamento de Múltiplas Versões**: Permite que os usuários alternem facilmente entre as versões do Python instaladas (por exemplo, `py -2.7` ou `py -3.10`) sem precisar modificar a variável de ambiente PATH.
- **Suporte a "Shebang" no Windows**: Possibilita o uso de linhas "shebang" (ex: `#!/usr/bin/env python3`) em scripts Python no Windows para especificar qual versão do interpretador deve ser usada, de forma semelhante aos sistemas Unix.
- **Execução Simplificada de Scripts**: Associa os arquivos `.py` ao lançador, permitindo que os scripts sejam executados de forma consistente, independentemente da versão do Python para a qual foram escritos.

2. [PEP 514 – Python registration in the Windows registry](https://peps.python.org/pep-0514/)
- **Detecção de Ambientes**: O objetivo é permitir que ferramentas de terceiros, como instaladores e IDEs, descubram e exibam corretamente todos os ambientes Python em uma máquina de usuário.
- **Prevenção de Conflitos**: Ajuda a evitar que instaladores de terceiros sobrescrevam os valores de registro do instalador oficial, o que pode fazer com que os usuários "percam" sua instalação original do Python.
- **Compatibilidade com Ferramentas**: Ferramentas como o lançador `py.exe` (definido no PEP 397), PyCharm e Visual Studio já utilizam essas informações para detectar automaticamente as instalações do Python.

3. [Taming the Python Hydra: A Modern Dev Environment with uv](https://caseywest.com/taming-the-python-hydra-a-modern-dev-environment-with-uv/)  
- **Ferramenta Unificada**: uv é uma ferramenta extremamente rápida, escrita em Rust, que substitui `pip`, `pip-tools`, `virtualenv` e, em alguns casos, até `poetry` e `pyenv`.
- **Velocidade e Eficiência**: É de 10 a 100 vezes mais rápido que o `pip` devido ao seu design moderno e ao cache global de pacotes, o que economiza espaço em disco e acelera a criação de ambientes.
- **Gerenciamento Simplificado**: Simplifica o fluxo de trabalho ao unificar a criação de ambientes virtuais, instalação de pacotes e travamento de dependências (`uv.lock`) em um único comando, como `uv pip sync`.
- **Ambientes e Dependências**: Por padrão, requer o uso de um ambiente virtual, garantindo o isolamento do projeto, e permitindo o gerenciamento de diferentes versões instaladas do Python.
- **Modernização do Fluxo de Trabalho**: Facilita a transição de projetos existentes que usam `requirements.txt` e promove o uso do `pyproject.toml` para uma gestão de dependências mais robusta e reproduzível

4. [Astral | uv | Docs | Reference | Environment variables](https://docs.astral.sh/uv/reference/environment/)  

5. [Astral | uv | Docs | Reference | CLI](https://docs.astral.sh/uv/reference/cli/)  