/*
* Copyright 2019 Google LLC
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
 * filterAccountsListBasedOnRequestFilters.js
 * Return only the accounts that meet the search criteria found in the request
 */

// Utility function. Check whether an account meets accountType criteria
function accountMeetsSearchCriteria(accountDetails,accountTypeFilter) {

    if ((accountTypeFilter !== null) && (accountDetails.type !== accountTypeFilter)) {
        return false;
    }

    return true;
}

// Get the accounts filter criteria, if any
var accountTypeFilter = context.getVariable("accountsFilter.accountType");
var fullListOfAccountsDetails = JSON.parse(context.getVariable("listOfAllAccountDetails"));
var newAccountList = [];
if (fullListOfAccountsDetails && fullListOfAccountsDetails.length > 0) {
    for (var i = 0; i < fullListOfAccountsDetails.length; i++) {
        if (accountMeetsSearchCriteria(fullListOfAccountsDetails[i], accountTypeFilter)) {
            // Add accountId to the list of accounts matching the filter criteria
            newAccountList.push(fullListOfAccountsDetails[i].accountId);
        }
    }

    context.setVariable("filteredAccountList", JSON.stringify(newAccountList));
    // print("Produced JSON String = " + JSON.stringify(newAccountList));
}