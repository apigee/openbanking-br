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
    local apigee_user_cred="-u $APIGEE_USER -p $APIGEE_PASSWORD -o $APIGEE_ORG -e $APIGEE_ENV"
    local apigee_token_cred="-t $APIGEE_TOKEN -o $APIGEE_ORG -e $APIGEE_ENV"
    if [[ -z "${APIGEE_TOKEN}" ]]; then
        to_eval="${to_eval} ${apigee_user_cred}"
    else
        to_eval="${to_eval} ${apigee_token_cred}"
    fi
    to_eval="${to_eval} ${suffix}"
    eval "$to_eval"
}

# Create Caches and dynamic KVM used by oidc proxy
echo "--->"  Creating cache OIDCState...
set_cred "apigeetool createcache" "-z OIDCState --description \"Holds state during authorization_code flow\" --cacheExpiryInSecs 600"
echo "--->"  Creating cache PushedAuthReqs...
set_cred "apigeetool createcache" "-z PushedAuthReqs --description \"Holds Pushed Authorisation Requests during authorization_code_flow\" --cacheExpiryInSecs 600"
# echo "--->"  Creating dynamic KVM PPIDs...
# apigeetool createKVMmap -u $APIGEE_USER -p $APIGEE_PASSWORD -o $APIGEE_ORG -e $APIGEE_ENV --mapName PPIDs --encrypted
echo "--->"  Creating dynamic KVM TokensIssuedForConsent...
set_cred "apigeetool createKVMmap" "--mapName TokensIssuedForConsent --encrypted"
# Create KVM that will hold consent information
echo "--->"  Creating dynamic KVM Consents...
set_cred "apigeetool createKVMmap" "--mapName Consents --encrypted"
# Create cache that will hold consent state (Used by basic consent management proxy)
echo "--->"  Creating cache ConsentState...
set_cred "apigeetool createcache" "-z ConsentState --description \"Holds state during consent flow\" --cacheExpiryInSecs 600"


# KVM CDSConfig

# KVM mockOBBRClient

 # Deploy Shared flows
cd ../src/shared-flows
for sf in $(ls .) 
do 
    echo "--->"  Deploying $sf Shared Flow 
    cd $sf
    set_cred "apigeetool deploySharedflow" "-n $sf"
    cd ..
 done

 # Deploy banking apiproxies
cd ../apiproxies/banking
for ap in $(ls .) 
do 
    echo "--->"  Deploying $ap Apiproxy
    cd $ap
    set_cred "apigeetool deployproxy" "-n $ap"
    cd ..
 done

 # Deploy Common Proxies
cd ../common
for ap in $(ls .) 
do 
    echo "--->"  Deploying $ap Apiproxy
    cd $ap
    set_cred "apigeetool deployproxy" "-n $ap"
    cd ..
 done

# Deploy Admin Proxies
cd ../admin/OBBR-Admin
echo "--->"  Deploying OBBR-Admin Apiproxy
set_cred "apigeetool deployproxy" "-n OBBR-Admin"
cd ..

# Deploy utils Proxies
cd ../utils/mock-obbr-client
echo "--->"  Deploying mock-obbr-client Apiproxy
set_cred "apigeetool deployproxy" "-n mock-obbr-client"
cd ..

# Deploy authnz related Proxies
cd ../authnz
for ap in $(ls .) 
do 
    echo "--->"  Deploying $ap Apiproxy
    cd $ap
    set_cred "apigeetool deployproxy" "-n $ap"
    cd ..
 done

# Create products


# Create Dev


# Create app

# Revert to original directory
cd ../../../..
