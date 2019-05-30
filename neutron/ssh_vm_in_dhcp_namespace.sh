#!/bin/bash
# Description: ssh vm in dhcp namespace, useful if controller node not reachable to tenant network.

IP=$1
USERNAME=${2:-root}
 
if [[ -z $IP ]]; then
    echo "Usage: $0 <ip> [username]"
    exit 0
fi
 
PORT_ID=$(neutron port-list | awk -F'|' "/\"$IP\"/{print \$2}")
if [[ -z $PORT_ID ]]; then
    echo "IP $IP not found in OpenStack!"
    exit 1
else
    echo "The port id is '$PORT_ID'"
fi
 
NETWORK_ID=$(neutron port-show $PORT_ID | awk -F '|' '/network_id/{print $3}' | sed 's/ //g')
IP_NETNS=qdhcp-$NETWORK_ID
if ! ip netns | grep -Pq "$IP_NETNS" ; then
    echo "The dhcp namespace is not in this node, please try another dhcp agent node."
    exit 1
fi
 
ip netns exec $IP_NETNS ssh -o StrictHostKeyChecking=no ${USERNAME}@${IP}
