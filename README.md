# Pipeline CI/CD com ECR e Autenticação OIDC

Este projeto monta um pipeline completo de integração e entrega contínua para uma aplicação Node.js simples, cobrindo desde o teste automatizado até a publicação da imagem Docker no Amazon ECR, sem usar nenhuma chave de acesso AWS de longa duração armazenada no GitHub. Em vez disso, a autenticação é feita por OIDC, um mecanismo mais seguro em que o GitHub Actions recebe uma identidade temporária e federada, verificada pela própria AWS a cada execução.

## Como funciona

A aplicação em si é pequena de propósito: um servidor Express que serve uma página estática e expõe um endpoint `/health` que devolve o status do serviço, útil para checagens de saúde em ambientes de produção. O foco do projeto está no pipeline em volta dela, não na aplicação.

O workflow do GitHub Actions roda em duas etapas encadeadas. A primeira instala as dependências da aplicação e executa os testes automatizados, funcionando como um portão de qualidade antes de qualquer coisa ser publicada. Se os testes passam e a mudança está sendo enviada para a branch principal, a segunda etapa entra em ação: ela assume um papel do IAM na AWS usando OIDC, autentica no Amazon ECR sem precisar de usuário e senha, constrói a imagem Docker da aplicação e envia essa imagem para o repositório ECR, marcada com o hash do commit que originou o build.

Toda a infraestrutura necessária para isso, o repositório ECR e o papel do IAM que o GitHub Actions assume, é provisionada com Terraform. O repositório ECR é criado com escaneamento automático de vulnerabilidades a cada push de imagem e com uma política de ciclo de vida que mantém apenas as dez imagens mais recentes, evitando acúmulo indefinido de versões antigas. Já o papel do IAM é configurado com uma política de confiança que só aceita requisições vindas especificamente deste repositório do GitHub, o que impede que outro repositório qualquer consiga assumir esse mesmo papel.

## Estrutura do projeto

```
ecr-ci-pipeline/
├── app/                        # aplicacao Node.js (Express) com testes
├── terraform/
│   ├── ecr.tf                  # repositorio ECR e politica de ciclo de vida
│   ├── iam-oidc.tf             # provider OIDC e role assumida pelo GitHub Actions
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── .github/workflows/ci.yml    # pipeline de teste, build e push para o ECR
```

## Como rodar

Para provisionar a infraestrutura na AWS:

```bash
cd terraform
terraform init
terraform apply
```

Para rodar a aplicação localmente:

```bash
cd app
npm install
npm start
```

O pipeline de CI roda automaticamente a cada push ou pull request na branch principal, sem necessidade de disparo manual.

## Observações

A escolha de OIDC em vez de chaves de acesso fixas é o ponto central deste projeto do ponto de vista de segurança: elimina a necessidade de guardar segredos de longa duração no GitHub, que são um alvo comum de vazamento, e restringe o escopo de quem pode assumir aquele papel a este repositório específico. Um próximo passo natural seria adicionar uma etapa de deploy da imagem publicada, seja em ECS, Kubernetes ou outro serviço de execução de containers, fechando o ciclo entre a imagem construída e a aplicação de fato rodando.
