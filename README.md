# [![https://cloud.google.com/apigee/](https://www.gstatic.com/images/branding/product/1x/google_cloud_48dp.png)](https://cloud.google.com/apigee/)  Open Banking Brazil Reference Implementation

## Overview

The [Banco Central do Brasil (BCB)](https://www.bcb.gov.br/en/about) and the [National Monetary Council (CMN)](https://www.bcb.gov.br/en/about/cmnen) define the Brazilian Open Banking environment as the sharing of data, products and services between regulated entities — financial institutions, payment institutions and other entities licensed by BCB — at the customers' discretion, as far as their own data is concerned (individuals or legal entities).

The regulation establishes different phases for introducing Open Banking APIs. [Phase 1](https://openbankingbrasil.atlassian.net/wiki/spaces/OB/pages/1671203/Dados+Abertos) comprises general information (Products and Services and Channels) about a participating institution. [Phase 2](https://openbankingbrasil.atlassian.net/wiki/spaces/OB/pages/1638627/Dados+Cadastrais+e+Transacionais) includes customer and account information. Phase 2 API are secured and require customer to provide consent. 

This is a reference implementation of *Open Banking Brazil*, using the Google Cloud Apigee API Management platform.

This implementation is based on version **2.0.1** of the standards and currently supports the following Banking APIs

- Phase 1
  - Channels
  - Products and Services

- Phase 2
  - Accounts

as well as the required security endpoints:
- Authorization
- Token
- Token Refresh
- Token Revocation
- UserInfo
- Introspection
- OpenID Provider Configuration
- Pushed Authorisation Requests (PARs)

consent endpoints:
 - Create, get, delete consent

resources endpoints:
 - Get resources included in consent

administration endpoints:
- Get Metrics

and common endpoints:
- Get Status
- Get Outages


Other APIs, including Dynamic Client Registration, will be gradually added.

This repository includes:
1. A set of reusable artefacts (Shared flows) that implement common functionality mandated by the standards (e.g: check request headers and parameters, include pagination information and self links in responses, etc.). These shared flows can be used in any Open Banking Brazil API implementation
2. API Proxies (*OBBR-ProductsServices, OBBR-Channels*, *OBBR-Accounts*) as a reference implementation. These API proxies return mock data from a fictional bank, and showcase how to include those reusable artefacts and best practices
3. An API proxy (*oidc-mock-provider*) that implements a standalone Open ID Connect Identity Provider, based on the open source package [oidc-provider](https://github.com/panva/node-oidc-provider)
4. An API Proxy (*OBBR-ConsentMgmtWithKVM*) that provides basic consent management capabilities, including managing consent screens, end user approval, querying scopes and resources included in a consent, and consent revocation 
5. An API Proxy (*oidc*) that  highlights one of the multiple patterns in which Apigee can interact with an Identity Provider. In this case, the standalone OIDC provider issues identity tokens, and Apigee issues opaque access and refresh tokens. It also interacts with the *OBBR-ConsentMgmtWithKVM* proxy to create/modify/revoke consents.
6. An API Proxy (*mock-obbr-client*) that mocks the functionality that a client participating in the Open Banking Brazil ecosystem needs to include: provide a JWKS that can be used to verify JWT tokens signed by the client. In addition, to make testing easier, it also has a helper facility to automatically generate Pushed Authorisation Requests (PARs)


The reference implementation can accelerate Open Banking implementation in multiple ways:
- Quick delivery of a sandbox API environment, returning mock data.
- Reusable artefacts (implemented as shared flows) can be included in real API implementations.
- Leverage the implemented Apigee/Standalone OIDC Provider interaction to kickstart the interaction between Apigee and a real OIDC Provider.

**This is not an officially supported Google product.**

## Setup

### Pre-requisites
- node.js 
- npm

### Installation
1. Install apigeetool
```
npm install --global apigeetool
```
2. Configure environment variables specifying the Apigee organization and environment where the artefacts will be deployed
```
export APIGEE_ORG=<your-org-name>
export APIGEE_ENV=<your-env-name>
export APIGEE_USER=<your-user-name>
# One of the following: 
export APIGEE_PASSWORD='<your-password>'   # Make sure to surround your password in single quotes, in case it includes special characters such as '$'
# or, if your Apigee Organization is configured to use SAML authentication
export APIGEE_TOKEN='<token generated with get_token utility>' # See https://docs.apigee.com/api-platform/system-administration/auth-tools
```
3. Run the following script from the root folder of the cloned repo.
```
./setup/deployOpenBankingBR.sh
```
This script deploys all the required artefacts
A Postman collection includes sample requests for the implemented APIs.


## Shared Flows

There are 17 shared flows that implement common functionality required by the Banking, Admin and other APIs.

1. *add-response-fapi-interaction-id*: Includes *x-fapi-interaction-id* header in responses and error messages
2. *add-response-headers-links-meta*: Includes in the response the mandated headers and  "meta" structure in the payload, including self links, pagination links, and pagination information, if applicable.
3. *apply-traffic-thresholds*: Implements [traffic threshold requirements](https://openbanking-brasil.github.io/areadesenvolvedor/#limites-de-trafego-de-requisicoes) for API requests.
4. *authenticate-with-private-key-jwt*: Implements *private_key_jwt* client authentication method. It can also be used to verify JWT tokens that contain Pushed Authorisation Requests (PARs)
5. *check-request-headers*: Makes sure mandatory headers are included in a request, and that headers have acceptable values. 
6. *check-request-is-allowed*: Validates whether a specific API request can be serviced, based on the validity of the access token provided, the scope associated with the access token and, if the request is for a particular resource, whether that resource was included in the end user consent. For valid requests not specifying a given resource (e.g: get accounts), it also returns all resources associated with the consent, so that the response can filter those resources not included.
7. *check-token-not-reused*: Validates that a JWT token has not been previously seen by caching its JTI claim for a specified amount of time. Used as part of PAR validation.
8. *collect-performance-slo*: Collects analytics information about the performance tier a request belongs to, and whether it meets its performance SLO. 
9. *decide-if-customer-present*: Determines whether a request has a customer present or is unattended. This will impact the traffic thresholds and performance SLOs applied to the request. Used by the *check-request-headers* shared flow, but can also be used independently.
10. *extract-consent-id-from-dynamic-scope*: Extracts the consent id included in the dynamic scope of a request or scope associated with an access token
11. *get-jwks-from-dynamic-uri*: Retrieves (and caches) a JWKS from a URI.
12. *get-ppid*: Returns a unique Pairwise Pseudonym Identifier based on a sector and a customer Id. Uses a KVM to persist the generated PPIds. The sector is an attribute of the registered app for a given client, determined at registration time.
13. *manage-tokens-by-consent-id*: Keeps track of the latest tokens (access and refresh tokens) associated with a given consent ID. Can revoke these tokens when a consent is revoked (either through consent revocation API or out of band, on a different channel) 
14. *paginate-backend-response*: Returns a subset of the full backend response, according to the pagination parameters included in a request.
15. *validate-audience-in-jwt*: Validates the audience claim in an authorisation JWT token
16. *validate-request-params*: Implements checks on request parameters: data types, admissible values, etc.
117. *verify-idp-id-token*: Verifies the JWT ID token issued by the IDP and stores the relevant claims into variables for reuse