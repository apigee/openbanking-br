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
* addCPFCNPJClaimsToUserInfo.js
* 
* Add the "cpf" and/or "cnpj" claims to the userinfo response, if requested
* 
**/


var theResponse = JSON.parse(context.getVariable("response.content"));
const theCPFClaim = context.getVariable("jwt.JWT-DecodeOIDCIdToken.decoded.claim.cpf");
const theCNPJClaim = context.getVariable("jwt.JWT-DecodeOIDCIdToken.decoded.claim.cnpj");
const cpfIsRequested = context.getVariable("oauthv2accesstoken.OAInfo-RetrieveAccessTokenDetails.accesstoken.CPFISRequested");
const cnpjIsRequested = context.getVariable("oauthv2accesstoken.OAInfo-RetrieveAccessTokenDetails.accesstoken.CNPJISRequested");

if ( (cpfIsRequested == "true") && (theCPFClaim !== null) && (theCPFClaim !== "")) {
    theResponse.cpf = theCPFClaim;
}
if ( (cnpjIsRequested == "true") && (theCNPJClaim !== null) && (theCNPJClaim !== "")) {
    theResponse.cnpj = theCNPJClaim;
}
context.setVariable("response.content", JSON.stringify(theResponse));