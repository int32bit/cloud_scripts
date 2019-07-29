#!/bin/bash
# Description: Find a link by ifindex, if ifindex not set, all the links will be listed.

DOCKER_NETNS_SCRIPT=./docker_netns.sh
IFINDEX=$1
if [[ -z $IFINDEX ]]; then
    for namespace in $($DOCKER_NETNS_SCRIPT); do
        printf "\e[1;31m%s: \e[0m\n" $namespace
        $DOCKER_NETNS_SCRIPT $namespace ip -c -o link
        printf "\n"
    done
else
    for namespace in $($DOCKER_NETNS_SCRIPT); do
        if $DOCKER_NETNS_SCRIPT $namespace ip -c -o link | grep -Pq "^$IFINDEX: "; then
            printf "\e[1;31m%s: \e[0m\n" $namespace
            $DOCKER_NETNS_SCRIPT $namespace ip -c -o link | grep -P "^$IFINDEX: ";
            printf "\n"
        fi
    done
fi
