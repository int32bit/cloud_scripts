#!/bin/bash
# Description: Clean orphan neutron agent if ironic node was deleted.
 
IRONIC_NODE_CACHE=/tmp/ironic_nodes.txt
OLD_IFS=$IFS
IFS=$'\n'
ironic node-list >$IRONIC_NODE_CACHE
for agent in $(neutron agent-list 2>/dev/null | grep 'ironic-neutron-agent'); do
    agent_id=$(echo $agent | awk -F '|' '{print $2}' | sed 's/\s//g')
    node_id=$(echo $agent | awk -F '|' '{print $4}' | sed 's/\s//g')
    if ! grep -q "$node_id" $IRONIC_NODE_CACHE; then
        echo "ironic node '$node_id' doesn't exist, try to delete orphan agent '$agent_id'"
        neutron agent-delete $agent_id 2>/dev/null
    fi
done
IFS=$OLD_IFS
rm -rf $IRONIC_NODE_CACHE
