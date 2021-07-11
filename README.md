[English](./README_EN.md)

# [![https://cloud.google.com/apigee/](https://www.gstatic.com/images/branding/product/1x/google_cloud_48dp.png)](https://cloud.google.com/apigee/)  Implementação de referência do Open Banking Brasil

## Visão geral

O [Banco Central do Brasil (BCB)](https://www.bcb.gov.br/en/about) e o [National Monetary Council (CMN)](https://www.bcb.gov.br/en/about/cmnen) definem o ambiente de Open Banking brasileiro como o compartilhamento de dados, produtos e serviços entre entidades reguladas - instituições financeiras, instituições de pagamento e outras entidades licenciadas pelo BCB - No caso de dados de clientes (pessoa física ou jurídica) é o cliente que decidirá quando e com quem ele deseja compartilhá-los no escopo do Open Banking.

O regulamento estabelece diferentes fases para a introdução de Open Banking APIs. A [Phase 1](https://openbanking-brasil.github.io/areadesenvolvedor/#fase-1-apis-do-open-banking-brasil) compreende informações gerais (Produtos e Serviços e Canais) sobre uma instituição participante.

Esta é uma implementação de referência do Open Banking Brasil, utilizando a plataforma de gerenciamento de APIs Apigee do Google Cloud.

Esta implementação é baseada nas versões v1.0.1-rc1.0 dos padrões e atualmente suporta as seguintes APIs:

- Fase 1
   - Canais de atendimento
   - Produtos e serviços

E também os seguintes endpoints de administração e comuns:

   - Obtenha métricas
   - Obter status
   - Obtenha interrupções (outages)

Outras APIs para as próximas fases serão adicionadas gradualmente.

Este repositório inclui:

1. Um conjunto de artefatos reutilizáveis (Fluxos Compartilhados - Shared Flows) que implementam a funcionalidade comum exigida pelos padrões (por exemplo: verificar cabeçalhos e parâmetros de solicitação, incluir informações de paginação e links próprios nas respostas, etc.). Esses fluxos compartilhados podem ser usados em qualquer implementação de API do Open Banking Brasil
2. API Proxies (OBBR-ProductsServices, OBBR-Channels) como implementação de referência. Esses API Proxies retornam dados simulados de um banco fictício e mostram como incluir esses artefatos reutilizáveis e práticas recomendadas

A implementação de referência pode acelerar a implementação do Open Banking de várias maneiras:

 - Entrega rápida de um ambiente de API de sandbox, retornando dados fictícios.
 - Artefatos reutilizáveis (Fluxos Compartilhados - Shared Flows) podem ser utilizados em implementações de API de produção.

**Este não é um produto Google com suporte oficial.**

## Guia de instalação

### Pré-requisitos
- node.js
- npm

### Instalação
1. instalar apigeetool
```
npm install --global apigeetool
```
2. Configure as variáveis de ambiente especificando a organização da Apigee e o ambiente onde os artefatos serão instalados
```
export APIGEE_ORG=<your-org-name>
export APIGEE_ENV=<your-env-name>
export APIGEE_USER=<your-user-name>
export APIGEE_PASSWORD='<your-password>'   # Se incluye caracteres especiais como '$', certifique-se de colocar sua senha entre aspas simples
```
3. Execute o seguinte script da diretório raiz do repo clonado.
```
./setup/deployOpenBankingBR.sh
```
Este script instala todos os artefatos necessários. Uma coleção do Postman inclui solicitações de amostra para as APIs implementadas.


## Fluxos Compartilhados (Shared Flows)

Existem 7 fluxos compartilhados que implementam a funcionalidade comum exigida pelo Open Banking, Admin e APIs de registro de cliente dinâmico.

1. *add-response-fapi-interaction-id*: Inclui cabeçalho *x-fapi-interaction-id* em respostas e mensagens de erro
2. *add-response-headers-links-meta*: Se aplicável, inclui na resposta os cabeçalhos obrigatórios e a "meta" estrutura na carga útil, incluindo links próprios, links de paginação e informações de paginação.
3. *apply-traffic-thresholds*: Implementa [requisitos de limite de tráfego](https://openbanking-brasil.github.io/areadesenvolvedor/#limites-de-trafego-de-requisicoes) para solicitações de API.
4. *check-request-headers*: Assegura que os cabeçalhos obrigatórios sejam incluídos em uma solicitação e que tenham valores aceitáveis.
5. *collect-performance-slo*: Coleta informações analíticas sobre a camada de desempenho à qual uma solicitação pertence e se ela atende ao seu SLO de desempenho.
6. *decide-if-customer-present*: Determina se uma solicitação tem um cliente presente ou não é atendida. Isso afetará os limites de tráfego e os SLOs de desempenho aplicados à solicitação. Usado pelo fluxo compartilhado *check-request-headers*, mas também pode ser usado independentemente.
7. *paginate-backend-response*: Retorna um subconjunto da resposta de back-end completa, de acordo com os parâmetros de paginação incluídos em uma solicitação.