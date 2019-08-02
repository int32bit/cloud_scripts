#!/bin/bash
# Description: OpenStack API test using curl.

TOKEN=$(openstack token issue | awk -F '|' '/\sid\s/{print $3}')

URL=${1}
METHOD=${2:-GET}
DATA=$3

if [[ -z $URL ]]; then
    echo "Usage: $0 <endpoint_url> [request_method] [post_data]"
    exit 1
fi
if [[ -z $DATA ]]; then
    response=$(curl -k -g -s -X ${METHOD} $URL -H "Accept: application/json" -H "X-Auth-Token: ${TOKEN}")
else
    response=$(curl -k -g -s -X ${METHOD} -d "$DATA" $URL -H "Accept: application/json" -H "X-Auth-Token: ${TOKEN}")
fi
 
if echo $response | python -m json.tool &>/dev/null; then
    echo $response | python -m json.tool
else
    echo -e $response
fi
