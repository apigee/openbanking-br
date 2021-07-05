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

 # Deploy Shared flows
cd src/shared-flows
for sf in $(ls .) 
do 
    echo "--->"  Deploying $sf Shared Flow 
    cd $sf
    apigeetool deploySharedflow -o $APIGEE_ORG -e $APIGEE_ENV -u $APIGEE_USER -p $APIGEE_PASSWORD -n $sf 
    cd ..
 done

 # Deploy banking apiproxies
cd ../apiproxies/banking
for ap in $(ls .) 
do 
    echo "--->"  Deploying $ap Apiproxy
    cd $ap
    apigeetool deployproxy -o $APIGEE_ORG -e $APIGEE_ENV -u $APIGEE_USER -p $APIGEE_PASSWORD -n $ap
    cd ..
 done

 # Deploy Common Proxies
cd ../common
for ap in $(ls .) 
do 
    echo "--->"  Deploying $ap Apiproxy
    cd $ap
    apigeetool deployproxy -o $APIGEE_ORG -e $APIGEE_ENV -u $APIGEE_USER -p $APIGEE_PASSWORD -n $ap
    cd ..
 done

# Deploy Admin Proxies
cd ../admin/OBBR-Admin
echo "--->"  Deploying OBBR-Admin Apiproxy
apigeetool deployproxy -o $APIGEE_ORG -e $APIGEE_ENV -u $APIGEE_USER -p $APIGEE_PASSWORD -n OBBR-Admin

# Revert to original directory
cd ../../../..
