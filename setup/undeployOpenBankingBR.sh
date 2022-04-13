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
    local apigee_user_cred="-u $APIGEE_USER -p $APIGEE_PASSWORD -o $APIGEE_ORG"
    local apigee_token_cred="-t $APIGEE_TOKEN -o $APIGEE_ORG"
    if [[ -z "${APIGEE_TOKEN}" ]]; then
        to_eval="${to_eval} ${apigee_user_cred}"
    else
        to_eval="${to_eval} ${apigee_token_cred}"
    fi
    to_eval="${to_eval}${env} ${suffix}"
    eval "$to_eval"
}

# Undeploy banking apiproxies
cd ../src/apiproxies/banking
for ap in $(ls .) 
do 
    echo "--->" Undeploying $ap Apiproxy
    cd $ap
    set_cred "apigeetool undeploy -o" "-n $ap"
    echo "--->" Deleting $ap Apiproxy
    set_cred "apigeetool delete" "-n $ap"
    cd ..
 done

 # Undeploy common apiproxies
cd ../common
for ap in $(ls .) 
do 
    echo "--->" Undeploying $ap Apiproxy
    cd $ap
    set_cred "apigeetool undeploy" "-n $ap"
    echo "--->" Deleting $ap Apiproxy
    set_cred "apigeetool delete" "-n $ap"
    cd ..
 done

# Undeploy OBBR-Admin proxy
cd ../admin/OBBR-Admin
echo "--->" Undeploying OBBR-Admin Apiproxy
set_cred "apigeetool undeploy" "-n OBBR-Admin"
echo "--->" Deleting OBBR-Admin Apiproxy
set_cred "apigeetool delete" "-n OBBR-Admin"

# Undeploy Shared flows
cd ../../../shared-flows
for sf in $(ls .) 
do 
    echo "--->" Undeploying $sf Shared Flow 
    cd $sf
    set_cred "apigeetool undeploySharedflow" "-n $sf"
    echo "--->" Deleting $sf Shared Flow 
    set_cred "apigeetool deleteSharedflow" "-n $sf"
    cd ..
done

# Revert to original directory
cd ../..