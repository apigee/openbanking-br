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
* checkPermissionIsAllowed.js
* Checks if the consent allows an operation, based on the permission required for that operation
* and the resource for which this operation will apply
**/

// Treat permissions as a string, because the JS interpreter does not support Array.includes 
const consentPermissions = context.getVariable("existingConsentInfo.permissions").toString();
const requiredPermission = context.getVariable("request.queryparam.required_permission");
const requiredResource = context.getVariable("request.queryparam.required_resource");
var isAllowed = consentPermissions.includes(requiredPermission);
if (isAllowed && (requiredResource !== null) && (requiredResource !== "")) {
    // Check required resource is included in consent. Its status should be AVAILABLE
    const consentResources = JSON.parse(context.getVariable("existingConsentInfo.resources"));
    var i = 0;
    var resourceFound = false;
    var resourceAvailable = false
    while (!resourceFound && i < consentResources.length) {
        var curResource = consentResources[i];
        if (curResource.resourceId == requiredResource) {
            resourceFound = true;
            resourceAvailable = (curResource.status == "AVAILABLE");
        }
        i++;
    }
    isAllowed = resourceFound && resourceAvailable;

}
// print("Consent permissions = " + consentPermissions + " - requiredPermission = " + requiredPermission);
// print("Consent resources = " + JSON.stringify(consentResources) + " - requiredResource = " + requiredResource + " - resourceFound = " + resourceFound + " - resourceAvailable = " + resourceAvailable + " - isAllowed = " + isAllowed );
context.setVariable("isAllowed", isAllowed);

