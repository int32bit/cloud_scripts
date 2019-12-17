#!/bin/bash
# Description: Create SereviceAccount as normal user and setup kubeconfig.
CA_LOCATION=/etc/kubernetes/pki/
CLUSTER_NAME=int32bit-kubernetes
API_SERVER=https://192.168.193.172:6443
# 用户名，必填参数
USERNAME=$1
NAMESPACE=${2:-default}
CONFIG_FILE=credentials/${USERNAME}@${CLUSTER_NAME}.config
if [[ -z $USERNAME ]]; then
  echo "Usage: $0 <username> [namespace]"
  exit 1
fi

# 创建serviceaccount
if ! kubectl create serviceaccount "${USERNAME}"; then
  echo "Fail to create serviceaccount '${USERNAME}'"
  exit 1
fi
TOKEN_NAME=$(kubectl get serviceaccounts "${USERNAME}" -o jsonpath={.secrets[0].name})
TOKEN=$(kubectl get secret "${TOKEN_NAME}" -o jsonpath={.data.token} | base64 -d)

# 配置config
kubectl config set-cluster "${CLUSTER_NAME}" \
  --certificate-authority="${CA_LOCATION}/ca.crt" \
  --server "${API_SERVER}" \
  --embed-certs=true \
  --kubeconfig="${CONFIG_FILE}"
kubectl config set-credentials "${USERNAME}" \
  --token="$TOKEN" \
  --kubeconfig="${CONFIG_FILE}"
kubectl config set-context "${USERNAME}@${CLUSTER_NAME}" \
  --cluster="${CLUSTER_NAME}" \
  --namespace="${NAMESPACE}" \
  --user="${USERNAME}" \
  --kubeconfig="${CONFIG_FILE}"
