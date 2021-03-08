#!/bin/bash
# Description: Export k8s resource(kubectl export is deprecated).
KIND=$1
RESOURCE_NAME=$2
if [[  -z $KIND ]] || [[ -z $RESOURCE_NAME ]]; then
    echo "Usage: $0 <resource kind> <resource name>"
    exit 1
fi
kubectl get $KIND $RESOURCE_NAME -o yaml | yq  -r '.metadata.annotations."kubectl.kubernetes.io/last-applied-configuration"' | yq -y '.'
