# Infraestrutura Automatizada (POS)

Este repositório contém exemplos de **infraestrutura como código (IaC)**
utilizando **Terraform** para criação de recursos na **AWS**, com foco
em fins educacionais.

---

## ⚠️ Pré-requisitos

Antes de rodar qualquer projeto, verifique se você possui:

### 1️⃣ AWS CLI instalado

Necessário para que o Terraform consiga se autenticar na AWS.

Instalação:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

Verifique a instalação:

```bash
aws --version
```

---

### 2️⃣ Credenciais AWS configuradas

Você deve ter um **IAM User** criado na AWS (não utilize a conta root).

Configure as credenciais:

```bash
aws configure
```

Será solicitado: - AWS Access Key ID - AWS Secret Access Key - Região
(ex: `us-east-1`) - Output format (pode deixar em branco)

---

### 3️⃣ Terraform instalado

```bash
terraform --version
```

Download: https://developer.hashicorp.com/terraform/downloads

---

### 4️⃣ Chave SSH

Você precisa de uma **chave SSH pública** para acessar a EC2.

Exemplo para gerar uma chave:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/minha-chave
```

O arquivo usado no Terraform será:

    ~/.ssh/minha-chave.pub

---

## 🚀 Rodando os projetos

O repositório contém **dois projetos** independentes:

| Projeto                    | Descrição                                                                                                                                     |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| **ec2-instance/**          | Cria uma instância EC2 básica na AWS (Amazon Linux).                                                                                          |
| **ec2-instance-with-vpc/** | Cria uma VPC completa com EC2 (Ubuntu) e usa **Ansible** para instalar e configurar um servidor web **Apache**. Projeto desenvolvido em aula. |

Execute os passos de cada projeto dentro da pasta correspondente (`cd ec2-instance/` ou `cd ec2-instance-with-vpc/`).

---

### 📂 ec2-instance/

Este projeto cria uma **instância EC2** na AWS utilizando Terraform (imagem Amazon Linux).

---

#### 1️⃣ Criar o arquivo de variáveis

Crie um arquivo chamado:

    terraform.tfvars

Com o seguinte conteúdo:

```hcl
project_id     = "ansible-vm"
region         = "us-east-1"
public_ip      = "0.0.0.0/32" # Substitua pelo seu IP público
ssh_public_key = ""           # Cole aqui sua chave SSH pública
```

---

#### 2️⃣ Inicializar o Terraform

```bash
terraform init
```

---

#### 3️⃣ Criar a infraestrutura

```bash
terraform apply
```

Confirme digitando `yes` quando solicitado.

---

#### 4️⃣ Testar o acesso SSH

Após a criação da EC2, utilize o IP público exibido no output:

```bash
ssh -i ~/.ssh/ansible-lab ec2-user@IP_DA_EC2
```

---

#### 5️⃣ Remover os recursos (MUITO IMPORTANTE)

Após finalizar os testes, destrua todos os recursos criados:

```bash
terraform destroy
```

---

### 📂 ec2-instance-with-vpc/

Este projeto foi desenvolvido **em aula**. Ele cria uma **VPC** na AWS (rede virtual, subnet pública, internet gateway, security group) e uma **instância EC2 com Ubuntu 22.04**. Em seguida, utilizamos **Ansible** para automatizar a instalação e configuração de um **servidor web Apache**, incluindo uma página inicial personalizada.

**Pré-requisito adicional:** [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html) instalado (para executar o playbook).

---

#### 1️⃣ Criar o arquivo de variáveis

Na pasta `ec2-instance-with-vpc/`, crie um arquivo:

    terraform.tfvars

Exemplo de conteúdo (ajuste o valor da chave SSH):

```hcl
project_name = "meu-projeto-vpc"
ssh_key      = ""   # Cole aqui sua chave SSH pública (ex.: conteúdo de ~/.ssh/minha-chave.pub)
```

---

#### 2️⃣ Inicializar o Terraform

```bash
terraform init
```

---

#### 3️⃣ Criar a infraestrutura

```bash
terraform apply
```

Confirme digitando `yes` quando solicitado. Ao final, anote o **IP público** exibido no output (`instance_ip`) — você usará no próximo passo.

---

#### 4️⃣ Configurar o inventário do Ansible

O playbook usa o grupo `ec2_instances`. Crie um arquivo de inventário (ex.: `inventory.ini`) na pasta do projeto com o IP da instância:

```ini
[ec2_instances]
IP_DA_SUA_EC2 ansible_user=ubuntu
```

Substitua `IP_DA_SUA_EC2` pelo valor de `instance_ip` do output do Terraform.

---

#### 5️⃣ Executar o playbook Ansible

Com a EC2 já criada e o inventário configurado, execute o playbook para instalar o Apache e configurar a página inicial (use o caminho da sua chave privada):

```bash
ansible-playbook apache-playbook.yml -i inventory.ini -u ubuntu --private-key ~/.ssh/minha-chave
```

Ajuste `~/.ssh/minha-chave` para o caminho da sua chave privada. Após a execução, acesse no navegador:

    http://IP_DA_SUA_EC2

---

#### 6️⃣ Remover os recursos (MUITO IMPORTANTE)

Após finalizar os testes, destrua todos os recursos:

```bash
terraform destroy
```

---
