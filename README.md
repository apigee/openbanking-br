# [![https://cloud.google.com/apigee/](https://www.gstatic.com/images/branding/product/1x/google_cloud_48dp.png)](https://cloud.google.com/apigee/)  Open Banking Brazil Reference Implementation

## Overview

The [Banco Central do Brasil (BCB)](https://www.bcb.gov.br/en/about) and the [National Monetary Council (CMN)](https://www.bcb.gov.br/en/about/cmnen) define the Brazilian Open Banking environment as the sharing of data, products and services between regulated entities — financial institutions, payment institutions and other entities licensed by BCB — at the customers' discretion, as far as their own data is concerned (individuals or legal entities).

The regulation establishes different phases for introducing Open Banking APIs. [Phase 1](https://openbanking-brasil.github.io/areadesenvolvedor/#fase-1-apis-do-open-banking-brasil) comprises general information (Products and Services and Channels) about a participating institution

This is a reference implementation of *Open Banking Brazil*, using the Google Cloud Apigee API Management platform.

This implementation is based on **v1.0.1-rc1.0** of the standards and currently supports the following Banking APIs

- Phase 1
  - Channels
  - Products and Services

as well as the required administration endpoints:
- Metadata Update
- Get Metrics

and discovery endpoints:
- Get Status
- Get Outages

Other APIs for the next Phases will be gradually added.

This repository includes:
1. A set of reusable artefacts (Shared flows) that implement common functionality mandated by the standards (e.g: check request headers and parameters, include pagination information and self links in responses, etc.). These shared flows can be used in any Open Banking Brazil API implementation
2. API Proxies (*OBBR-ProductsServices, OBBR-Channels*) as a reference implementation. These API proxies return mock data from a fictional bank, and showcase how to include those reusable artefacts and best practices

The reference implementation can accelerate Open Banking implementation in multiple ways:
- Quick delivery of a sandbox API environment, returning mock data.
- Reusable artefacts (implemented as shared flows) can be included in real API implementations.

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
2. Configure environment variables specifying the Apigee organisation and environment where the artefacts will be deployed
```
export APIGEE_ORG=<your-org-name>
export APIGEE_ENV=<your-env-name>
export APIGEE_USER=<your-user-name>
export APIGEE_PASSWORD='<your-password>'   # Make sure to surround your password in single quotes, in case it includes special characters such as '$'
```
3. Run the following script from the root folder of the cloned repo.
```
./setup/deployOpenBankingBR.sh
```
This script deploys all the required artefacts
A Postman collection includes sample requests for the implemented APIs.


## Shared Flows

There are 7 shared flows that implement common functionality required by the Banking, Admin and dynamic client registration APIs.

1. *add-response-fapi-interaction-id*: Includes *x-fapi-interaction-id* header in responses and error messages
2. *add-response-headers-links-meta*: Includes in the response the mandated headers and  "meta" structure in the payload, including self links, pagination links, and pagination information, if applicable.
3. *apply-traffic-thresholds*: Implements [traffic threshold requirements](https://openbanking-brasil.github.io/areadesenvolvedor/#limites-de-trafego-de-requisicoes) for API requests.
4. *check-request-headers*: Makes sure mandatory headers are included in a request, and that headers have acceptable values. 
5. *collect-performance-slo*: Collects analytics information about the performance tier a request belongs to, and whether it meets its performance SLO. 
6. *decide-if-customer-present*: Determines whether a request has a customer present or is unattended. This will impact the traffic thresholds and performance SLOs applied to the request. Used by the *check-request-headers* shared flow, but can also be used independently.
7. *paginate-backend-response*: Returns a subset of the full backend response, according to the pagination parameters included in a request.