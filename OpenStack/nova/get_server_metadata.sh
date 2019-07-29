#!/bin/bash
# Description: Get server metadata outside the vm, useful to debug cloud-init metadata.

SECRET="" # Get from /etc/nova.conf:[neutron]metadata_proxy_shared_secret
METADATA_SERVER=http://127.0.0.1:8775
METADATA_URL=$METADATA_SERVER/openstack/latest
TEMP_PYTHON_SCRIPT=/tmp/sign_instance.py

INSTANCE_UUID=$1
REQUEST_PATH=$2

cat >$TEMP_PYTHON_SCRIPT <<EOF
import six
import sys
import hmac
import hashlib

def sign_instance_id(instance_id, secret=''):
    if isinstance(secret, six.text_type):
        secret = secret.encode('utf-8')
    if isinstance(instance_id, six.text_type):
        instance_id = instance_id.encode('utf-8')
    return hmac.new(secret, instance_id, hashlib.sha256).hexdigest()


if __name__ == "__main__":
    if len(sys.argv) > 2:
        print(sign_instance_id(sys.argv[1], sys.argv[2]))
    else:
        print(sign_instance_id(sys.argv[1]))
EOF

if [[ -z $INSTANCE_UUID ]]; then
    echo "Usage: $0 <instance_id>"
    echo -e "\tFor example: $0 07db451b-7eaf-4c78-977b-982263b02a22 metadata.json"
    exit 1
fi
TENANT_ID=$(nova show ${INSTANCE_UUID} | awk '/tenant_id/{print $4}')
SIGN_INSTANCE_ID=$(python $TEMP_PYTHON_SCRIPT $INSTANCE_UUID $SECRET)
RESPONSE=$(curl -sL \
    -H "X-Instance-ID:$INSTANCE_UUID" \
    -H "X-Instance-ID-Signature:$SIGN_INSTANCE_ID" \
    -H "X-Tenant-ID:$TENANT_ID" \
    $METADATA_URL/$REQUEST_PATH
)

if echo $RESPONSE | python -m json.tool &>/dev/null; then
    echo $RESPONSE | python -m json.tool
else
    echo -e $RESPONSE
fi
rm -rf $TEMP_PYTHON_SCRIPT
