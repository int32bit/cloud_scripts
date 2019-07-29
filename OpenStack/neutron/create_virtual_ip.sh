#!/bin/bash
# Description: Create a virtual IP for a group of member ip.
 
args=($@)
size=${#args[@]}
 
if [[ $size -lt 2 ]]; then
    echo "Usage: <member_ip_1> <member_ip_2> ... <member_ip_n> <vip>"
    exit 1
fi
vip=${args[-1]}
ips=${args[@]:0:$((size - 1))}
 
for ip in ${ips[@]}; do
    port_id=$(neutron port-list | grep -P -w $ip | awk -F '|' '{print $2}' | sed 's/\s//g')
    echo "Add vip $vip to port $port_id($ip)"
    neutron port-update --allowed-address-pair ip_address=$vip $port_id
done
