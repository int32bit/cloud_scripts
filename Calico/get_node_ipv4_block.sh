#!/bin/bash
# Description: List all ipv4 block of Calico Nodes.
ENDPOINTS=http://192.168.1.68:2379,http://192.168.1.254:2379,http://192.168.1.245:2379
for host in $(etcdctl --endpoints $ENDPOINTS ls /calico/ipam/v2/host/); do
    etcdctl --endpoints $ENDPOINTS ls  $host/ipv4/block | awk -F '/' '{sub(/-/,"/",$NF)}{print $6,$NF}'
done | sort
