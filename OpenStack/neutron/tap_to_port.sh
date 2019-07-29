#!/bin/bash
# Description: Convert tap to Neutron port.

TAP_NAME=$1

if [[ -z $TAP_NAME ]]; then
    echo "Usage $0 <tap_name>"
    exit 1
fi

# tap6fee5e4d-56 -> 6fee5e4d-56
PORT_PREFIX=${TAP_NAME:3}
PORT_ID=$(neutron port-list | grep $PORT_PREFIX | cut -d '|' -f 2 | tr -d ' ')
PORT_INFO_PATH=/tmp/port_info_${PORT_ID}
neutron port-show $PORT_ID >$PORT_INFO_PATH
IP=$(cat $PORT_INFO_PATH | awk -F '|' '/fixed_ips/{print $3}' | tr -d '"' | grep -Po "ip_address: [a-f0-9:.]+" | cut -d ':' -f 2- | tr -d ' ')
MAC=$(cat $PORT_INFO_PATH | awk -F '|' '$2~/mac_address/{print $3}' | tr -d ' ')
DEVICE_OWNER=$(cat $PORT_INFO_PATH | grep 'device_owner' | cut -d '|' -f 3 | tr -d ' ')

printf "%s: %s  %s %s %s\n" $TAP_NAME $PORT_ID $IP $MAC $DEVICE_OWNER

# Clean works
rm -rf $PORT_INFO_PATH
