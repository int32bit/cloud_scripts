#!/bin/bash
# Description: List iptables rules of security group for a server, should run it on compute node.
SERVER_UUID=$1
if [[ -z $SERVER_UUID ]]; then
    echo "Usage: $0 <server_uuid>"
    exit 1
fi
PORT_ID=$(neutron port-list -F id -f value -- --device_id=$SERVER_UUID)
if [[ -z $PORT_ID ]]; then
    echo "Port not found for server '$SERVER_UUID'."
    exit 1
fi
PORT_PREFIX=${PORT_ID:0:10}

echo "# Ingress rules: "
iptables-save | grep "^-A neutron-openvswi-i$PORT_PREFIX"

echo -e "\n# Egress rules: "
iptables-save | grep "^-A neutron-openvswi-o$PORT_PREFIX"
