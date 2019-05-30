#!/bin/bash
# Description: Dumps all ipmi commands from ironic conductor log, useful to troubleshoot ironic issue.

set -e -o pipefail
NODE=$1
IRONIC_LOG=/var/log/ironic/ironic-conductor.log
if [[ -z $NODE ]]; then
    echo "Usage: $0 <node>"
    exit 1
fi

get_node_driver_info()
{
    NODE=$1
    PROPERTY=$2
    if [[ -z $NODE ]]; then
        echo "Usage: $0 <node> <attr>"
        echo "For example: $0 node-1"
        echo "             $0 node-1 ipmi_address"
        exit 1
    fi
    NODE_INFO=$(openstack baremetal node show $NODE | awk -F '|' '/driver_info/{print $3}' | sed "s/u'/\"/g" | tr "'" '"')
    if [[ -z $PROPERTY ]]; then
        echo $NODE_INFO | jq
    else
        echo $NODE_INFO | jq ".ipmi_address" | tr -d '"'
    fi
}

IPMI_ADDRESS=$(get_node_driver_info $NODE ipmi_address)
cat $IRONIC_LOG | grep ipmitool | grep $IPMI_ADDRESS | grep -o '".*"' | tr -d '"'
