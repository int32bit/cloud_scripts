#!/bin/bash
# Description: Dumps all tap devices to Neutron port.

# Dump ovs tap devices
for tap in $(ovs-vsctl show | grep -P 'Port "' | grep -Pv "(eth)|(qvo)" | tr -d '"' | awk '{print $2}'); do
    ./tap_to_port.sh $tap
done

# Dump linux bridge tap devices
for tap in $(brctl show | grep -Po 'tap\w{8}-\w{2}'); do
    ./tap_to_port.sh $tap
done
