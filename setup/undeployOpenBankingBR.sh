#/bin/bash


#
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Credentials settings helper function
to_eval=""
function set_cred(){
    to_eval=$1
    local suffix=$2
    local env=" -e $APIGEE_ENV"
    if [[ "$1" == *"delete"* ]]; then
    env=""
    fi
    local apigee_user_cred="-u $APIGEE_USER -p $APIGEE_PASSWORD -o $APIGEE_ORG -e $APIGEE_ENV"
    local apigee_token_cred="-t $APIGEE_TOKEN -o $APIGEE_ORG -e $APIGEE_ENV" 
    if [[ -z "${APIGEE_TOKEN}" ]]; then
        to_eval="${to_eval} ${apigee_user_cred}"
    else
        to_eval="${to_eval} ${apigee_token_cred}"
    fi
    to_eval="${to_eval}${env} ${suffix}"
    eval "$to_eval"
}
# Credentials settings helper function for org level config
function set_cred_org(){
    to_eval=$1
    local suffix=$2
    local apigee_user_cred="-u $APIGEE_USER -p $APIGEE_PASSWORD -o $APIGEE_ORG"
    local apigee_token_cred="-t $APIGEE_TOKEN -o $APIGEE_ORG"
    if [[ -z "${APIGEE_TOKEN}" ]]; then
        to_eval="${to_eval} ${apigee_user_cred}"
    else
        to_eval="${to_eval} ${apigee_token_cred}"
    fi
    to_eval="${to_eval} ${suffix}"
    eval "$to_eval"
}



# Remove OBBR Test Client app
# If no developer name has been set, use a default
if [ -z "$OBBR_TEST_DEVELOPER_EMAIL" ]; then  OBBR_TEST_DEVELOPER_EMAIL=OBBR-Test-Developer@somefictitioustestcompany.com; fi;
echo "--->"  Removing Test App: OOBRTestApp...
set_cred_org "apigeetool deleteApp" " --email $OBBR_TEST_DEVELOPER_EMAIL --name OBBRTestApp" 

# Remove OBBR Test Developer
echo "--->"  Removing Test Developer: $OBBR_TEST_DEVELOPER_EMAIL
set_cred_org "apigeetool deleteDeveloper" "--email $OBBR_TEST_DEVELOPER_EMAIL"


# Remove Products
echo "--> Removing Products"
echo "--->"  Removing API Product: "Accounts"
set_cred_org "apigeetool deleteProduct" "--productName \"OBBRAccounts\"  "
echo "--->"  Removing API Product: "OIDC"
set_cred_org "apigeetool deleteProduct" "--productName \"OBBROIDC\"  "
echo "--->"  Removing API Product: "Consents"
set_cred_org "apigeetool deleteProduct" "--productName \"OBBRConsents\"  "
echo "--->"  Removing API Product: "Resources"
set_cred_org "apigeetool deleteProduct" "--productName \"OBBRResources\"  "
echo "--->"  Removing API Product: "Admin"
set_cred_org "apigeetool deleteProduct" "--productName \"OBBRAdmin\"  "

# Deploy authnz related Proxies
cd src/apiproxies/authnz
for ap in $(ls .) 
do 
    echo "--->" Undeploying $ap Apiproxy
    cd $ap
    set_cred "apigeetool undeploy" "-n $ap"
    echo "--->" Deleting $ap Apiproxy
    set_cred_org "apigeetool delete" "-n $ap"
    cd ..
 done

# Undeploy utils Proxies
cd ../utils/mock-obbr-client
echo "--->"  Undeploying mock-obbr-client Apiproxy
set_cred "apigeetool undeploy" "-n mock-obbr-client"
echo "--->" Deleting mock-obbr-client Apiproxy
set_cred_org "apigeetool delete" "-n mock-obbr-client"
cd ..

# Undeploy OBBR-Admin proxy
cd ../admin/OBBR-Admin
echo "--->" Undeploying OBBR-Admin Apiproxy
set_cred "apigeetool undeploy" "-n OBBR-Admin"
echo "--->" Deleting OBBR-Admin Apiproxy
set_cred_org "apigeetool delete" "-n OBBR-Admin"
cd ..

 # Undeploy common apiproxies
cd ../common
for ap in $(ls .) 
do 
    echo "--->" Undeploying $ap Apiproxy
    cd $ap
    set_cred "apigeetool undeploy" "-n $ap"
    echo "--->" Deleting $ap Apiproxy
    set_cred_org "apigeetool delete" "-n $ap"
    cd ..
 done

# Undeploy banking apiproxies
cd ../banking
for ap in $(ls .) 
do 
    echo "--->" Undeploying $ap Apiproxy
    cd $ap
    set_cred "apigeetool undeploy" "-n $ap"
    echo "--->" Deleting $ap Apiproxy
    set_cred_org "apigeetool delete" "-n $ap"
    cd ..
 done

# Undeploy Shared flows
cd ../../shared-flows
for sf in $(ls .) 
do 
    echo "--->" Undeploying $sf Shared Flow 
    cd $sf
    set_cred "apigeetool undeploySharedflow" "-n $sf"
    echo "--->" Deleting $sf Shared Flow 
    set_cred_org "apigeetool deleteSharedflow" "-n $sf"
    cd ..
done

# Remove KVM Maps
echo "--> Removing Key Value Maps"
echo "--->"  Removing KVM mockOBBRClient...
set_cred "apigeetool deletekvmmap" "--mapName mockOBBRClient"
echo "--->"  Removing KVM Consents...
set_cred "apigeetool deletekvmmap" "--mapName Consents"
echo "--->"  Removing KVM TokensIssuedForConsent...
set_cred "apigeetool deletekvmmap" "--mapName TokensIssuedForConsent"
echo "--->"  Removing KVM OBBRConfig...
set_cred "apigeetool deletekvmmap" "--mapName OBBRConfig"

# Remove caches
echo "--> Removing Caches"
echo "--->"  Removing cache OIDCState...
set_cred "apigeetool deletecache" "-z OIDCState"
echo "--->"  Removing cache PushedAuthReqs...
set_cred "apigeetool deletecache" "-z PushedAuthReqs"
echo "--->"  Removing cache ConsentState...
set_cred "apigeetool deletecache" "-z ConsentState"

# Revert to original directory
cd ../..