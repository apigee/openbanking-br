  /*
* Copyright 2021 Google LLC
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     https://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

/**
 * @file
 * addOptionalClaimsIfPresent.js
 * Add optional additional claims if query params are present 
 *  */
 
 var additionalClaims = JSON.parse(context.getVariable("additionalClaimsVar"));
 print("Before - Additional Claims = " + JSON.stringify(additionalClaims));
 const requested_cpf_str = context.getVariable("request.queryparam.requested_cpf");
 const is_cpf_essential_str = context.getVariable("request.queryparam.is_cpf_essential");
 const is_cpf_essential = ( ( is_cpf_essential_str !== null) && ( is_cpf_essential_str !== "" ) && ( is_cpf_essential_str.toLowerCase() === "true") );
 const requested_cnpj_str = context.getVariable("request.queryparam.requested_cnpj");
 const is_cnpj_essential_str = context.getVariable("request.queryparam.is_cnpj_essential");
 const is_cnpj_essential = ( ( is_cnpj_essential_str !== null) && ( is_cnpj_essential_str !== "" ) && ( is_cnpj_essential_str.toLowerCase() === "true") );
 print("requested_cpf_str = " + requested_cpf_str + " - is_cpf_essential = " + is_cpf_essential + " - requested_cnpj_str = " + requested_cnpj_str + " - is_cnpj_essential = " + is_cnpj_essential);
 if ( is_cpf_essential ) {
     additionalClaims.claims.userinfo.cpf = {};
     additionalClaims.claims.userinfo.cpf.essential = true;
 }
 // If a specific cpf is requested, add it as value for the cpf claim, and set essential to whatever value has been requested, or default value
 if ( (requested_cpf_str !== null) && ( requested_cpf_str !== "" ) ) {
     additionalClaims.claims.userinfo.cpf = {};
     additionalClaims.claims.userinfo.cpf.value = requested_cpf_str;
     additionalClaims.claims.userinfo.cpf.essential = is_cpf_essential;
 }
 if ( is_cnpj_essential ) {
     additionalClaims.claims.userinfo.cnpj = {};
     additionalClaims.claims.userinfo.cnpj.essential = true;
 }
 // If a specific cnpj is requested, add it as value for the cnpj claim, and set essential to whatever value has been requested, or default value
 if ( (requested_cnpj_str !== null) && ( requested_cnpj_str !== "" ) ) {
     additionalClaims.claims.userinfo.cnpj = {};
     additionalClaims.claims.userinfo.cnpj.value = requested_cnpj_str;
     additionalClaims.claims.userinfo.cnpj.essential = is_cnpj_essential;
 }
 print("After - Additional Claims = " + JSON.stringify(additionalClaims));
 context.setVariable("additionalClaimsVar", JSON.stringify(additionalClaims));