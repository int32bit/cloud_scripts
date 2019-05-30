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
IP=$(cat $PORT_INFO_PATH  | grep 'fixed_ips' | grep -Po '(\d{1,3}\.){3}\d{1,3}')
MAC=$(cat $PORT_INFO_PATH | grep 'mac_address' | cut -d '|' -f 3 | tr -d ' ')
DEVICE_OWNER=$(cat $PORT_INFO_PATH | grep 'device_owner' | cut -d '|' -f 3 | tr -d ' ')
printf "%s: %s %s %s\n" $PORT_ID $IP $MAC $DEVICE_OWNER

# Clean works
rm -rf $PORT_INFO_PATH
