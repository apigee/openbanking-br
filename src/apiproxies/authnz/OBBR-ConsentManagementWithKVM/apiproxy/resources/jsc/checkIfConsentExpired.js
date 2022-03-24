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
* checkIfConsentExpired.js
* Checks if the consent has expired, if so, sets status to EXPIRED 
**/

const consentExpiry = new Date(context.getVariable("existingConsentInfo.expires_at"))
var consentExpiryInEpochMillis = consentExpiry.getTime();
const d = new Date();
var nowInEpochMillis = d.getTime();
print("nowInEpochMillis = " + nowInEpochMillis + " - consentExpiry = " + consentExpiry + " - consent_expires_in_millis = " + consentExpiryInEpochMillis);

if (consentExpiryInEpochMillis < nowInEpochMillis) {
    // Consent expired
    print("Consent expired");
    context.setVariable("existingConsentInfo.status","EXPIRED");
}

var consentExpiryInSeconds = Math.trunc(consentExpiryInEpochMillis/1000) - Math.trunc(nowInEpochMillis/1000);
context.setVariable("consentExpiryInSeconds", String(consentExpiryInSeconds));
print("consentExpiryInSeconds = " + consentExpiryInSeconds);


 