**This file is generated by git precommit hook, DO NOT MODIFY IT!**

# Catalog

## OpenStack/nova

1. [create_libvirt_ceph_secret.sh](./OpenStack/nova/create_libvirt_ceph_secret.sh): Create a libvirt secret for Ceph.
2. [get_server_metadata.sh](./OpenStack/nova/get_server_metadata.sh): Get server metadata outside the vm, useful to debug cloud-init metadata.

## OpenStack/neutron

1. [create_virtual_ip.sh](./OpenStack/neutron/create_virtual_ip.sh): Create a virtual IP for a group of member ip.
2. [get_server_security_group_iptables_rules.sh](./OpenStack/neutron/get_server_security_group_iptables_rules.sh): List iptables rules of security group for a server, should run it on compute node.
3. [ssh_vm_in_dhcp_namespace.sh](./OpenStack/neutron/ssh_vm_in_dhcp_namespace.sh): ssh vm in dhcp namespace, useful if controller node not reachable to tenant network.
4. [tap_to_port.sh](./OpenStack/neutron/tap_to_port.sh): Convert tap to Neutron port.
5. [dump_all_taps.sh](./OpenStack/neutron/dump_all_taps.sh): Dumps all tap devices to Neutron port.

## OpenStack/ironic

1. [dump_ipmi_commands.sh](./OpenStack/ironic/dump_ipmi_commands.sh): Dumps all ipmi commands from ironic conductor log, useful to troubleshoot ironic issue.
2. [clean_orphan_neutron_agent.sh](./OpenStack/ironic/clean_orphan_neutron_agent.sh): Clean orphan neutron agent if ironic node was deleted.

## Docker

1. [docker_netns.sh](./Docker/docker_netns.sh): List or enter Docker network namespace by container id or name.
2. [find_links.sh](./Docker/find_links.sh): Find a link by ifindex, if ifindex not set, all the links will be listed.

## common

1. [api_requests.sh](./common/api_requests.sh): OpenStack API test using curl.
