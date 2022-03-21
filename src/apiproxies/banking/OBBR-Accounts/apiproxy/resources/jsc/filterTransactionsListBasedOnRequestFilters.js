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
 * filterTransactionsListBasedOnRequestFilters.js
 * Return only the transactions that meet the search criteria found in the request
 */

// Utility function. Check whether a given transaction meets filter criteria
function txMeetsSearchCriteria(txDetails, accountIdFilter, newestTimeFilter, oldestTimeFilter, creditDebitFilter) {

    if ((accountIdFilter !== null) && (txDetails.accountId !== accountIdFilter)) {
        return false;
    }
    
    // print("Starting date filter criteria checks. oldestTimeFilter = " + oldestTimeFilter + " - newestTimeFilter = " + newestTimeFilter);
	// Check transaction time
	var txTime = new Date(txDetails.transactionDate);
	print("txTime (Posting) = " + txTime);
	if ( (txTime > newestTimeFilter) || (txTime < oldestTimeFilter)) {
	   // print("txTime: " + txTime + " does not match");
	    return false;
	}
	
	// Check transaction credit/debit
	
	if (creditDebitFilter) {
	    if (txDetails.creditDebitType != creditDebitFilter) {
	       // print("Transaction credit/debit type (" + txDetails.creditDebitType + ") does not meet credit/debit filter (" + creditDebitFilter + ")");
	        return false;
	    }
	}

// 	print("Transaction meets filter criteria");
	return true;

}

// Get the transaction filter criteria, if any
var accountIdFilter = context.getVariable("theAccountId");
var newestTimeFilter = new Date(context.getVariable("transactionsFilter.toBookingDate"));
var oldestTimeFilter = new Date(context.getVariable("transactionsFilter.fromBookingDate"));
if (newestTimeFilter === "Invalid Date" || newestTimeFilter.getTime() === 0) {
    // Set it to today
    newestTimeFilter = new Date();
    }
if (oldestTimeFilter === "Invalid Date" || oldestTimeFilter.getTime() === 0) {
    // Set it to newestTimeFilter - 90 days
    // Substract 90 days in milliseconds
    var dateOffset = (24*60*60*1000) * 90; //90 days
    oldestTimeFilter = new Date();
    oldestTimeFilter.setTime((newestTimeFilter.getTime() - dateOffset));
}
var creditDebitFilter = context.getVariable("transactionsFilter.creditDebitIndicator");
var fullListOfTransactionsDetails = JSON.parse(context.getVariable("listOfAllTransactionsDetails"));
var newTxList = [];
if (fullListOfTransactionsDetails && fullListOfTransactionsDetails.length > 0) {
    for (var i = 0; i < fullListOfTransactionsDetails.length; i++) {
        if (txMeetsSearchCriteria(fullListOfTransactionsDetails[i], accountIdFilter, newestTimeFilter, oldestTimeFilter, creditDebitFilter)) {
            // Only include in the response transactions matching the filter criteria. Also remove accountId, which shouldn't be part of the response
            delete fullListOfTransactionsDetails[i].accountId;
            newTxList.push(fullListOfTransactionsDetails[i]);
        }
    }
}   
var results = {};
results.data = newTxList;
context.setVariable("response.content",JSON.stringify(results));
