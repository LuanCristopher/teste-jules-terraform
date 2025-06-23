# Terraform Google Cloud Infrastructure

Este projeto provisiona uma infraestrutura no Google Cloud Platform (GCP) usando Terraform. Ele cria duas Virtual Private Clouds (VPCs) em regiões diferentes, duas máquinas virtuais (VMs) (uma em cada VPC) e estabelece o VPC Peering entre as duas VPCs para permitir a comunicação via ICMP (ping) entre as VMs.

## Estrutura de Diretórios

O projeto está organizado em módulos para melhor clareza e reutilização:

```
.
├── main.tf                 # Módulo raiz: define provedores e chamadas de módulo
├── variables.tf            # Módulo raiz: define variáveis de entrada
├── outputs.tf              # Módulo raiz: define valores de saída
├── modules/
│   ├── vpc/
│   │   ├── main.tf         # Módulo VPC: cria VPC, sub-redes e regras de firewall
│   │   ├── variables.tf    # Módulo VPC: variáveis de entrada
│   │   └── outputs.tf      # Módulo VPC: valores de saída
│   ├── vm/
│   │   ├── main.tf         # Módulo VM: cria instâncias de VM
│   │   ├── variables.tf    # Módulo VM: variáveis de entrada
│   │   └── outputs.tf      # Módulo VM: valores de saída
│   └── peering/
│       ├── main.tf         # Módulo Peering: cria conexões de VPC Peering
│       └── variables.tf    # Módulo Peering: variáveis de entrada
└── README.md               # Este arquivo
```

## Recursos Criados

### Região: `us-west1` (Padrão: `var.region_1`)
*   **VPC:** Nome definido por `var.vpc_1_name` (Padrão: `luan-vpc-1`)
    *   Sub-rede: Nome `[var.vpc_1_name]-subnet` (Ex: `luan-vpc-1-subnet`), CIDR `10.0.1.0/24` (configurável no `main.tf` ao chamar o módulo VPC)
*   **VM:** Nome definido por `var.vm_1_name` (Padrão: `vm-1`)
    *   Conectada à VPC acima.
    *   Tipo de máquina: `e2-medium` (configurável no `main.tf` ao chamar o módulo VM)
    *   Imagem: `debian-cloud/debian-11` (configurável no `main.tf` ao chamar o módulo VM)

### Região: `us-east1` (Padrão: `var.region_2`)
*   **VPC:** Nome definido por `var.vpc_2_name` (Padrão: `luan-vpc-2`)
    *   Sub-rede: Nome `[var.vpc_2_name]-subnet` (Ex: `luan-vpc-2-subnet`), CIDR `10.0.2.0/24` (configurável no `main.tf` ao chamar o módulo VPC)
*   **VM:** Nome definido por `var.vm_2_name` (Padrão: `vm-2`)
    *   Conectada à VPC acima.
    *   Tipo de máquina: `e2-medium` (configurável no `main.tf` ao chamar o módulo VM)
    *   Imagem: `debian-cloud/debian-11` (configurável no `main.tf` ao chamar o módulo VM)

### Conectividade entre VPCs
*   **VPC Peering:** Estabelecido entre as duas VPCs.
    *   As conexões de peering são nomeadas dinamicamente com base nos nomes das VPCs (ex: `luan-vpc-1-to-luan-vpc-2`).
*   **Regras de Firewall (por VPC):**
    *   `[nome-da-vpc]-allow-icmp-internal`: Permite tráfego ICMP de `0.0.0.0/0` (qualquer origem dentro da VPC e VPCs pareadas). Isso é essencial para o ping entre `vm-1` e `vm-2`.
    *   `[nome-da-vpc]-allow-ssh`: Permite tráfego TCP na porta `22` (SSH) de `0.0.0.0/0`. **Para ambientes de produção, é fortemente recomendado restringir `source_ranges` para IPs específicos por segurança.**

## Como Usar

### Pré-requisitos

1.  **Conta no Google Cloud Platform:** Uma conta ativa no GCP e um projeto criado.
2.  **Google Cloud SDK (gcloud CLI):** Instalado e configurado.
    *   Autentique-se: `gcloud auth application-default login`
    *   Defina seu projeto padrão: `gcloud config set project SEU_PROJECT_ID_AQUI`
3.  **Terraform:** Instalado. A configuração utiliza o provider Google `~> 4.0`.

### Configuração

1.  **Clone o repositório (se aplicável) ou crie os arquivos e diretórios conforme a estrutura descrita.**
2.  **Defina o ID do Projeto (Obrigatório):**
    A maneira mais comum é criar um arquivo `terraform.tfvars` na raiz do projeto:
    ```terraform
    // terraform.tfvars
    project_id = "SEU_PROJECT_ID_AQUI"
    ```
    Alternativamente, defina a variável de ambiente `TF_VAR_project_id` ou passe-a diretamente na linha de comando (`-var="project_id=SEU_PROJECT_ID_AQUI"`).
3.  **(Opcional) Personalize Outras Variáveis:**
    Você pode modificar os valores padrão para regiões, nomes de VPCs, VMs, etc., definidos em `variables.tf`, adicionando-os ao seu arquivo `terraform.tfvars`. Por exemplo:
    ```terraform
    // terraform.tfvars
    project_id = "meu-projeto-gcp-123"
    region_1   = "us-central1"
    vm_1_name  = "minha-vm-app"
    vpc_1_name = "vpc-producao"
    ```

### Comandos do Terraform

Execute estes comandos no diretório raiz do projeto.

1.  **Inicialização:**
    ```bash
    terraform init
    ```
    Este comando inicializa o diretório de trabalho, baixando os providers necessários.

2.  **Planejamento:**
    ```bash
    terraform plan
    ```
    (Se não estiver usando `terraform.tfvars` para `project_id`, adicione `-var="project_id=SEU_PROJECT_ID_AQUI"`)
    Revise o plano para entender quais recursos serão criados, modificados ou destruídos.

3.  **Aplicação:**
    ```bash
    terraform apply
    ```
    (Se não estiver usando `terraform.tfvars` para `project_id`, adicione `-var="project_id=SEU_PROJECT_ID_AQUI"`)
    O Terraform solicitará confirmação antes de provisionar a infraestrutura. Digite `yes`.

4.  **Destruição:**
    ```bash
    terraform destroy
    ```
    (Se não estiver usando `terraform.tfvars` para `project_id`, adicione `-var="project_id=SEU_PROJECT_ID_AQUI"`)
    Este comando removerá todos os recursos gerenciados por esta configuração do Terraform. Confirme digitando `yes`.

## Saídas (Outputs)

Após uma aplicação bem-sucedida (`terraform apply`), o Terraform exibirá os seguintes valores de saída (definidos em `outputs.tf`):

*   `vm_1_ip`: O endereço IP interno da `vm-1`.
*   `vm_2_ip`: O endereço IP interno da `vm-2`.
*   `vpc_1_self_link`: O self link da primeira VPC (ex: `luan-vpc-1`).
*   `vpc_2_self_link`: O self link da segunda VPC (ex: `luan-vpc-2`).

Essas saídas são úteis para verificar a configuração e para conectar-se às VMs. Por exemplo, para testar a conectividade ICMP:
1.  Conecte-se a `vm-1` via SSH (usando o GCP Console ou `gcloud compute ssh vm-1 --zone=[ZONA_DA_VM_1]`).
2.  Dentro da `vm-1`, execute: `ping <IP_DA_VM_2_OBTIDO_NA_SAIDA>`
    (Ex: `ping 10.0.2.X`)

Lembre-se de substituir `[ZONA_DA_VM_1]` pela zona correta da `vm-1` (ex: `us-west1-a`).
