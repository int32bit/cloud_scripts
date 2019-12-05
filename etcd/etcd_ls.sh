#!/bin/bash
# Description: ls etcd keys by prefix just like etcd v2.
KEY_FILE=/etc/kubernetes/pki/etcd/server.key
CERT_FILE=/etc/kubernetes/pki/etcd/server.crt
CA_FILE=/etc/kubernetes/pki/etcd/ca.crt
ENDPOINTS=https://127.0.0.1:2379
PREFIX=${1:-/}
ORIG_PREFIX="$PREFIX"

LAST_CHAR=${PREFIX:${#PREFIX}-1:1}
if [[ $LAST_CHAR != '/' ]]; then
    PREFIX="$PREFIX/" # Append  '/' at the end if not exist
fi

for ITEM in $(etcdctl --key="$KEY_FILE" \
                   --cert="$CERT_FILE" \
                   --cacert="$CA_FILE" \
		   --endpoints "$ENDPOINTS" \
		   get "$PREFIX" --prefix=true --keys-only | grep "$PREFIX"); do
    PREFIX_LEN=${#PREFIX}
    CONTENT=${ITEM:$PREFIX_LEN}
    POS=$(expr index "$CONTENT" '/')
    if [[ $POS -le 0 ]]; then
	    POS=${#CONTENT} # No '/', it's not dir, get whole str
    fi
    CONTENT=${CONTENT:0:$POS}
    LAST_CHAR=${CONTENT:${#CONTENT}-1:1}
    if [[ $LAST_CHAR == '/' ]]; then
        CONTENT=${CONTENT:0:-1}
    fi
    echo "${PREFIX}${CONTENT}"
done | sort | uniq

etcdctl --key="$KEY_FILE" \
       	--cert="$CERT_FILE"  \
	--cacert="$CA_FILE" \
	--endpoints "$ENDPOINTS" get "$ORIG_PREFIX"
