# Infraestrutura Automatizada (POS)

Este repositório contém exemplos de **infraestrutura como código (IaC)**
utilizando **Terraform** para criação de recursos na **AWS**, com foco
em fins educacionais.

------------------------------------------------------------------------

## ⚠️ Pré-requisitos

Antes de rodar qualquer projeto, verifique se você possui:

### 1️⃣ AWS CLI instalado

Necessário para que o Terraform consiga se autenticar na AWS.

Instalação:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

Verifique a instalação:

``` bash
aws --version
```

------------------------------------------------------------------------

### 2️⃣ Credenciais AWS configuradas

Você deve ter um **IAM User** criado na AWS (não utilize a conta root).

Configure as credenciais:

``` bash
aws configure
```

Será solicitado: - AWS Access Key ID - AWS Secret Access Key - Região
(ex: `us-east-1`) - Output format (pode deixar em branco)

------------------------------------------------------------------------

### 3️⃣ Terraform instalado

``` bash
terraform --version
```

Download: https://developer.hashicorp.com/terraform/downloads

------------------------------------------------------------------------

### 4️⃣ Chave SSH

Você precisa de uma **chave SSH pública** para acessar a EC2.

Exemplo para gerar uma chave:

``` bash
ssh-keygen -t ed25519 -f ~/.ssh/ansible-lab
```

O arquivo usado no Terraform será:

    ~/.ssh/ansible-lab.pub

------------------------------------------------------------------------

## 🚀 Rodando os projetos

### 📂 ec2-instance/

Este projeto cria uma **instância EC2** na AWS utilizando Terraform.

------------------------------------------------------------------------

### 1️⃣ Criar o arquivo de variáveis

Crie um arquivo chamado:

    terraform.tfvars

Com o seguinte conteúdo:

``` hcl
project_id     = "ansible-vm"
region         = "us-east-1"
public_ip      = "0.0.0.0/32" # Substitua pelo seu IP público
ssh_public_key = ""           # Cole aqui sua chave SSH pública
```

------------------------------------------------------------------------

### 2️⃣ Inicializar o Terraform

``` bash
terraform init
```

------------------------------------------------------------------------

### 3️⃣ Criar a infraestrutura

``` bash
terraform apply
```

Confirme digitando `yes` quando solicitado.

------------------------------------------------------------------------

### 4️⃣ Testar o acesso SSH

Após a criação da EC2, utilize o IP público exibido no output:

``` bash
ssh -i ~/.ssh/ansible-lab ec2-user@IP_DA_EC2
```

------------------------------------------------------------------------

### 5️⃣ Remover os recursos (MUITO IMPORTANTE)

Após finalizar os testes, destrua todos os recursos criados:

``` bash
terraform destroy
```


------------------------------------------------------------------------
