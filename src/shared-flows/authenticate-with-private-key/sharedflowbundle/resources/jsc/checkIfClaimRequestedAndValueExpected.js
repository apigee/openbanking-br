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
* checkIfClaimRequestedAndValueExpected.js
* Checks if a given claim has been requested as an essential claim
* and, optionally, if an expected value is provided. 
* This will be used in the authorization step to verify that it matches 
* the authenticated user corresponding claims in their id_token
**/

var claimObj = JSON.parse(context.getVariable("PKJwtAdditionalClaims." + properties.claimName));
// print("claimObj for " + properties.claimName + " = " + JSON.stringify(claimObj));
const isRequested = (claimObj !== null) && (claimObj.essential !== null) && (claimObj.essential === true);
print ("isRequested = " + isRequested);
context.setVariable("PKJwtAdditionalClaims."+properties.claimName + "_is_requested", isRequested);
var expectedValue;
if (isRequested && (claimObj.value !== null)) {
    expectedValue = claimObj.value;
    if (properties.claimName == "cpf") {
        // The expected value is a string
         context.setVariable("PKJwtAdditionalClaims."+properties.claimName + "_expected_value", expectedValue);
    }
    else {
        // For cnpj, the expected value is an ARRAY of strings
        context.setVariable("PKJwtAdditionalClaims."+properties.claimName + "_expected_value", JSON.stringify(expectedValue));
    }
}
else {
    // Set expected value to none
    context.setVariable("PKJwtAdditionalClaims."+properties.claimName + "_expected_value", 'none');
}
    
// print ("expectedValue = " + expectedValue);