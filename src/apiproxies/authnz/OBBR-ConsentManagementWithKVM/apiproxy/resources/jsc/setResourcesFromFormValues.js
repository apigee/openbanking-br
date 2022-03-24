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
* setResourcesFromFormValues.js
* Obtains the resources information to be included in the consent
* based on the form values returned.
* For each included resource the form will return a form parameter of name resourceType and value resourceId
**/

// The list of resource types to consider. Treat it as string, because the JS interpreter does not have an array.includes method.
const resourceTypes = ["ACCOUNT", "CREDIT_CARD_ACCOUNT", "LOAN", "FINANCING", "UNARRANGED_ACCOUNT_OVERDRAFT"];
const resourceTypesAsStr = resourceTypes.join(" ");
var requestedResources = [];

// Iterate over all param names
var formParamsNamesStr = context.getVariable("request.formparams.names")+'';
// formParamsNamesStr represents a collection, convert it to a JS array of strings
var formParamsNames = formParamsNamesStr.slice(1,-1).split(",");
// print("params names array = " + JSON.stringify(formParamsNames));

for(i = 0; i < formParamsNames.length; i++) {
    var curParamName = formParamsNames[i].trim();
    // print("Processing param name = " + curParamName);
    if (resourceTypesAsStr.includes(curParamName)) {
        // We're only interested in the formparams whose names are in the resourceTypes list
        // Iterate over all values
        var curParamCount = context.getVariable("request.formparam."+ curParamName + ".values.count");
       for(j = 0; j < Number(curParamCount); j++) {
            var curParamValue = context.getVariable(("request.formparam."+ curParamName + "." + (j+1)));
            // print("ParamValue #" + j + " = " + curParamValue );
            var newResource = {};
            newResource.resourceId = curParamValue;
            newResource.type = curParamName;
            newResource.status = "AVAILABLE";
            requestedResources.push(newResource);
        }
    }
}

// print("requestedResources = " + JSON.stringify(requestedResources));
context.setVariable("requestedConsentInfo.resources",JSON.stringify(requestedResources));
