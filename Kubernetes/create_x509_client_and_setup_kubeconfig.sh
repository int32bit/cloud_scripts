#!/bin/bash
# Description: Create x509 client and setup kubeconfig.
CA_LOCATION=/etc/kubernetes/pki/
CLUSTER_NAME=int32bit-kubernetes
API_SERVER=https://192.168.193.172:6443
# 用户名，必填参数
USERNAME=$1
# 组名，如果不填，则和用户名一致
GROUPNAME=${2:-$USERNAME}
# 默认的namespace，不填则为default
NAMESPACE=${3:-default}

if [[ -z $USERNAME ]]; then
  echo "Usage: $0 <username> [groupname] [namespace]"
  exit 1
fi
mkdir -p "$USERNAME"

# 证书生成位置
CSR_FILE="${USERNAME}/${USERNAME}.csr"
KEY_FILE="${USERNAME}/${USERNAME}.key"
CRT_FILE="${USERNAME}/${USERNAME}.crt"
CONFIG_FILE=credentials/${USERNAME}@${CLUSTER_NAME}.config

# 生成证书
openssl genrsa -out "${KEY_FILE}" 2048
openssl req -new -key "${KEY_FILE}" -out  "${CSR_FILE}" -subj "/CN=${USERNAME}/O=${GROUPNAME}"
openssl x509 -req -in "${CSR_FILE}" -CA $CA_LOCATION/ca.crt -CAkey $CA_LOCATION/ca.key -CAcreateserial -out "${CRT_FILE}" -days 365

# 配置config
kubectl config set-cluster "${CLUSTER_NAME}" \
  --certificate-authority="${CA_LOCATION}/ca.crt" \
  --server "${API_SERVER}" \
  --embed-certs=true \
  --kubeconfig="${CONFIG_FILE}"
kubectl config set-credentials "${USERNAME}" \
  --client-certificate=$(readlink -f ${CRT_FILE}) \
  --client-key=$(readlink -f ${KEY_FILE}) \
  --embed-certs=true \
  --kubeconfig="${CONFIG_FILE}"
kubectl config set-context "${USERNAME}@${CLUSTER_NAME}" \
  --cluster="${CLUSTER_NAME}" \
  --namespace="${NAMESPACE}" \
  --user="${USERNAME}" \
  --kubeconfig="${CONFIG_FILE}"
