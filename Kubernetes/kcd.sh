#!/bin/bash
# Description: Change kubernetes namespace using bash select(List all, choose one).
kcd() {
    NAMESPACE=${1}
    CURRENT_NAMESPACE=$(kubectl  config get-contexts | tail -n 1 | awk '{print $5}')
    NAMESPACE_COUNT=$(kubectl  get namespaces  | wc -l)
    let NAMESPACE_COUNT--
    if [[ -z $NAMESPACE ]]; then
        PS3="Please select namespace: "
        select NAMESPACE in $(kubectl  get namespaces -o jsonpath='{.items[*].metadata.name}'); do
            if [[ -n $NAMESPACE ]]; then
                break
            else
                echo "Invalid input: please choose number from 1 to $NAMESPACE_COUNT!"
            fi
        done
    fi
    if [[ $NAMESPACE != $CURRENT_NAMESPACE ]]; then
        echo "Change Kubernetes namespaces from $CURRENT_NAMESPACE to $NAMESPACE"
        kubectl config set-context --current --namespace $NAMESPACE
    fi
}
