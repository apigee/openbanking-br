[English](./README.md)

# [![https://cloud.google.com/apigee/](https://www.gstatic.com/images/branding/product/1x/google_cloud_48dp.png)](https://cloud.google.com/apigee/)  Implementação de referência do Open Banking Brasil

## Visão geral

O [Banco Central do Brasil (BCB)](https://www.bcb.gov.br/en/about) e o [National Monetary Council (CMN)](https://www.bcb.gov.br/en/about/cmnen) definem o ambiente de Open Banking brasileiro como o compartilhamento de dados, produtos e serviços entre entidades reguladas - instituições financeiras, instituições de pagamento e outras entidades licenciadas pelo BCB - No caso de dados de clientes (pessoa física ou jurídica) é o cliente que decidirá quando e com quem ele deseja compartilhá-los no escopo do Open Banking.

O regulamento estabelece diferentes fases para a introdução de Open Banking APIs. A [Phase 1](https://openbanking-brasil.github.io/areadesenvolvedor/#fase-1-apis-do-open-banking-brasil) compreende informações gerais (Produtos e Serviços e Canais) sobre uma instituição participante.

Esta é uma implementação de referência do Open Banking Brasil, utilizando a plataforma de gerenciamento de APIs Apigee do Google Cloud.

Esta implementação é baseada nas versões v1.0.1-rc1.0 dos padrões e atualmente suporta as seguintes APIs:

- Fase 1
   - Canais de atendimento
   - Produtos e serviços
- Fase 2
   - Contas

Os seguintes recursos de segurança também estão incluídos:
   - Autorização
   - Token
   - Atualização de token
   - Revogação de token
   - Informação de usuário
   - Introspecção
   - Configuração do provedor OpenID
   - Solicitações de autorização push (PARs)

endpoints de consentimento:
   - Criar, obter, excluir consentimento

terminais de recursos:
   - Obtenha recursos incluídos no consentimento

endpoints de administração:
   - Obter Métricas

e pontos de extremidade comuns:
   - Obter status do serviço
   - Obter interrupções de serviço



Este repositório inclui:

1. Um conjunto de artefatos reutilizáveis (Fluxos Compartilhados - Shared Flows) que implementam a funcionalidade comum exigida pelos padrões (por exemplo: verificar cabeçalhos e parâmetros de solicitação, incluir informações de paginação e links próprios nas respostas, etc.). Esses fluxos compartilhados podem ser usados em qualquer implementação de API do Open Banking Brasil
2. API Proxies (*OBBR-ProductsServices, OBBR-Channels*, *OBBR-Accounts*) como implementação de referência. Esses API Proxies retornam dados simulados de um banco fictício e mostram como incluir esses artefatos reutilizáveis e práticas recomendadas
3. Um proxy de API (*oidc-mock-provider*) que implementa um provedor de identidade Open ID Connect autônomo, baseado no projecto de código aberto [oidc-provider](https://github.com/panva/node-oidc- fornecedor)
4. Um proxy de API (*OBBR-ConsentMgmtWithKVM*) que fornece recursos básicos de gerenciamento de consentimento, incluindo gerenciamento de telas de consentimento, aprovação do usuário final, consulta de escopos e recursos incluídos em um consentimento e revogação de consentimento
5. Um proxy de API (*oidc*) que destaca um dos vários padrões nos quais a Apigee pode interagir com um provedor de identidade. Nesse caso, o provedor OIDC autônomo emite tokens de identidade e a Apigee emite tokens de acesso e atualização opacos. Ele também interage com o proxy *OBBR-ConsentMgmtWithKVM* para criar/modificar/revogar consentimentos.
6. Uma API Proxy (*mock-obbr-client*) que simula a funcionalidade que um cliente participante do ecossistema Open Banking Brasil precisa incluir: fornecer um JWKS que possa ser usado para verificar tokens JWT assinados pelo cliente. Além disso, para facilitar os testes, ele também possui um recurso auxiliar para gerar automaticamente Pushed Authorization Requests (PARs)

A implementação de referência pode acelerar a implementação do Open Banking de várias maneiras:

 - Entrega rápida de um ambiente de API de sandbox, retornando dados fictícios.
 - Artefatos reutilizáveis (Fluxos Compartilhados - Shared Flows) podem ser utilizados em implementações de API de produção.
 - Aproveite a interação Apigee/Provedor OIDC autônomo implementada para iniciar a interação entre a Apigee e um provedor OIDC real.

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
export APIGEE_PASSWORD='<your-password>'   # Se incluye caracteres especiais como '$', certifique-se de colocar sua senha entre aspas simples, ou caso inclua caracteres especiais como '$'
# se sua organização da Apigee estiver configurada para usar a autenticação SAML
export APIGEE_TOKEN='<token gerado com o utilitário get_token>' # Consulte https://docs.apigee.com/api-platform/system-administration/auth-tools
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
4. *authenticate-with-private-key-jwt*: Implementa o método de autenticação de cliente *private_key_jwt*. Ele também pode ser usado para verificar tokens JWT que contêm solicitações de autorização push (PARs)
5. *check-request-headers*: Garante que os cabeçalhos obrigatórios sejam incluídos em uma solicitação e que os cabeçalhos tenham valores aceitáveis.
6. *check-request-is-allowed*: valida se uma solicitação de API específica pode ser atendida, com base na validade do token de acesso fornecido, no escopo associado ao token de acesso e, se a solicitação for para um recurso específico, se esse recurso foi incluído no consentimento do usuário final. Para solicitações válidas que não especificam um determinado recurso (por exemplo: obter contas), ele também retorna todos os recursos associados ao consentimento, para que a resposta possa filtrar os recursos não incluídos.
7. *check-token-not-reused*: Valida se um token JWT não foi visto anteriormente armazenando em cache sua declaração JTI por um período de tempo especificado. Usado como parte da validação PAR.
8. *collect-performance-slo*: coleta informações analíticas sobre a camada de desempenho à qual uma solicitação pertence e se ela atende ao SLO de desempenho.
9. *decide-if-customer-present*: determina se uma solicitação tem um cliente presente ou não é atendida. Isso afetará os limites de tráfego e os SLOs de desempenho aplicados à solicitação. Usado pelo fluxo compartilhado *check-request-headers*, mas também pode ser usado independentemente.
10. *extract-consent-id-from-dynamic-scope*: extrai o id de consentimento incluído no escopo dinâmico de uma solicitação ou escopo associado a um token de acesso
11. *get-jwks-from-dynamic-uri*: Recupera (e armazena em cache) um JWKS de um URI.
12. *get-ppid*: Retorna um Pairwise Pseudonym Identifier exclusivo com base em um setor e um ID de cliente. Usa um KVM para persistir os PPIds gerados. O setor é um atributo do aplicativo cadastrado para um determinado cliente, determinado no momento do cadastro.
13. *manage-tokens-by-consent-id*: mantém o controle dos tokens mais recentes (tokens de acesso e atualização) associados a um determinado ID de consentimento. Pode revogar esses tokens quando um consentimento é revogado (por meio da API de revogação de consentimento ou fora da banda, em um canal diferente)
14. *paginate-backend-response*: Retorna um subconjunto da resposta de back-end completa, de acordo com os parâmetros de paginação incluídos em uma solicitação.
15. *validate-audience-in-jwt*: valida a declaração de público em um token JWT de autorização
16. *validate-request-params*: Implementa verificações nos parâmetros de solicitação: tipos de dados, valores admissíveis, etc.
17. *verify-idp-id-token*: verifica o token de ID JWT emitido pelo IDP e armazena as declarações relevantes em variáveis ​​para reutilização
