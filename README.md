# TIU LANCHES - App
| :placard: Vitrine.Dev |     |
| -------------  | --- |
| :sparkles: Nome        | **Tiu Lanches - App**
| :label: Tecnologias | Terraform, GitHub Actions
| :rocket: URL         | 
| :fire: Desafio     | Tech Challenge FIAP

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

<!-- Inserir imagem com a #vitrinedev ao final do link -->
![](https://blog.azureacademy.com.br/wp-content/uploads/2019/11/0-1360x600.png#vitrinedev)

# Detalhes do projeto
## Objetivo
Projeto criado para complementar o projeto principal [Tiu Lanches](https://github.com/luisferrarezi/tiulanches)

# Arquitetura
Este repositório é exclusivo para cuidar da estrutura para aplicação subir pelo AKS e preparar a estrutura para o deploy da function criada para registrar o login realizado pelo usuário.

## Segurança
A branch main está bloqueada para commit direto.

É necessário ser criado um pull request para que após aprovado possa ser realizado o merge para a branch principal

## Automação
Atualmente para esta branch existe 1 nível de automação, explicado abaixo:

- Push: este é executado somente após o PR ter sido aprovado e executado o merge para a main, primeiro é checado que se o arquivo terraform está dentro do esperado para o HCL. Após esta validação é então solicitado para o administrador do projeto autorização para aplicar as alterações no azure. Implementei essa regra para ser mais um nível de segurança para não se permitir que a estrutura seja alterada sem a devida supervisão.

Na azure foi criado o usuário github para que ele tenha as permissões necessárias para criar toda a estrutura para a function e AKS.

## Infraestrutura
Através do Terraform é criada a estrutura da seguinte forma:

- Cria um container registry na Azure para que o deploy da imagem fique dentro da infra.
- Cria o AKS com uma máquina basica com ubuntu com 1 pod, podendo ser escalado para até 3 pods. Deixei a cargo da configuração padrão da azure esse controle.
- Cria o Storage Account para ser usada pela function
- Cria o Service Plan para definir que como a function será executada
- Cria a estrutura onde a function é alocada
- Faz deploy do Nginx no AKS
- Faz deploy do Kafka no AKS

### Variáveis de Ambiente
Existem variáveis de ambiente que são indispensáveis para que a estrutura seja corretamente criada:
- CLIENT_ID=<CLIENT_ID> - Esta informação está no github criado no azure
- CLIENT_SECRET=<CLIENT_SECRET> - Esta informação deve ser criada para o usuário github no azure
- DATASOURCE_PASSWORD=<DATASOURCE_PASSWORD> - Password para a function conectar a base de dados
- DATASOURCE_URL=<DATASOURCE_URL> - Url de conexão para a function conectar a base de dados
- DATASOURCE_USERNAME=<DATASOURCE_USERNAME> - Usuário para a function conectar a base de dados
- SUBSCRIPTION_ID=<SUBSCRIPTION_ID> - Esta informação está no github criado no azure
- TENANT_ID=<TENANT_ID> - Esta informação está no github criado no azure
- TF_API_TOKEN=<TF_API_TOKEN> - Esta informação se encontra no https://app.terraform.io/ onde é necessário existir um token para que o git actions utilize os recursos da própria HashiCorp disponibiliza para criar a automação com o actions.
- AZURE_CREDENTIALS=<AZURE_CREDENTIALS> - Credenciais necessárias do usuário github para que possa realizar o deploy
- CLUSTER_NAME=<CLUSTER_NAME> - O nome do cluster que foi criado para o AKS
- RESOURSE_GROUP=<RESOURSE_GROUP> - Resouce Group destinado na Azure para a aplicação
- SUBSCRIPTION=<SUBSCRIPTION> - Subscription ao qual o AKS criado pertence
