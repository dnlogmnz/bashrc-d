# Bashrc.d

Shell scripts para `$HOME/.bashrc.d`.

Este repositório contém uma coleção de scripts bash projetados para configurar e melhorar o ambiente de desenvolvimento Linux.
Cada script fornece funções ou variáveis de ambiente específicas para diferentes ferramentas e fluxos de trabalho.

## Estrutura do Repositório

Os scripts estão organizados no diretório `src/home/.bashrc.d/`, e cada arquivo atende a um propósito específico. Abaixo está uma visão geral:

### Scripts de Configuração de Ambiente

- **00-bash-envs.sh**: Configura variáveis de ambiente básicas para o Bash, incluindo o ajuste do PATH e outras conveniências.
- **12-terraform-envs.sh**: Configura variáveis de ambiente para o Terraform/OpenTofu, incluindo diretórios de cache e arquivos de configuração.
- **41-uv-envs.sh**: Configura variáveis de ambiente para o UV, um gerenciador de pacotes Python.

### Scripts de Funções

- **11-git-functions.sh**: Funções úteis para interagir com o Git CLI, como `git-info` e `git-config`.
- **21-aws-functions.sh**: Funções para facilitar o uso do AWS CLI, como `aws-info`, `aws-use` e `aws-setup`.
- **31-mongodb-functions.sh**: Funções para interagir com o MongoDB Atlas CLI, como `mongodb-info` e `_load_mongodb_env`.
- **41-uv-functions.sh**: Conjunto de funções para gerenciar projetos Python com o UV, como `uv-info` e `uv-new-project`.
- **42-python-functions.sh**: Funções relacionadas ao uso de Python gerenciado pelo UV, incluindo `py-info`.

### Scripts de Alias

- **14-docker-aliases.sh**: Define aliases úteis para o Docker CLI, como `docker-clean`, `docker-stop-all`, e `docker-logs`.

### Scripts de Integração de Ferramentas

- **23-gemini-cli-envs.sh**: Configura variáveis de ambiente para o Google Gemini CLI, incluindo autenticação, configurações de modelo, e comportamento.
