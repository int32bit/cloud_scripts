#!/bin/bash
# Description: List or enter Docker network namespace by container id or name.

NAMESPACE=$1

if [[ -z $NAMESPACE ]]; then
    ls -1 /var/run/docker/netns/
    exit 0
fi

NAMESPACE_FILE=/var/run/docker/netns/${NAMESPACE}

if [[ ! -f $NAMESPACE_FILE ]]; then
    NAMESPACE_FILE=$(docker inspect -f "{{.NetworkSettings.SandboxKey}}" $NAMESPACE 2>/dev/null)
fi

if [[ ! -f $NAMESPACE_FILE ]]; then
    echo "Cannot open network namespace '$NAMESPACE': No such file or directory"
    exit 1
fi

shift

if [[ $# -lt 1 ]]; then
    echo "No command specified"
    exit 1
fi

nsenter --net=${NAMESPACE_FILE} $@
