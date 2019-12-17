#!/bin/bash
# Description: Decode ServiceAccount Token(JWT).

# base64url解码
decode_base64_url() {
  LEN=$((${#1} % 4))
  RESULT="$1"
  if [ $LEN -eq 2 ]; then
    RESULT+='=='
  elif [ $LEN -eq 3 ]; then
    RESULT+='='
  fi
  echo "$RESULT" | tr '_-' '/+' | base64 -d
}

# 解码JWT
decode_jwt()
{
  JWT_RAW=$1
  for line in $(echo "$JWT_RAW" | awk -F '.' '{print $1,$2}'); do
    RESULT=$(decode_base64_url "$line")
    echo "$RESULT" | python -m json.tool
  done
}

# 获取k8s sa token
get_k8s_sa_token()
{
  NAME=$1
  TOKEN_NAME=$(kubectl get sa "$NAME" -o jsonpath='{.secrets[0].name}')
  kubectl get secret "${TOKEN_NAME}" -o jsonpath='{.data.token}' | base64 -d
}

main()
{
  NAME=$1
  if [[ -z $NAME ]]; then
    echo "Usage: $0 <secret_name>"
    exit 1
  fi
  TOKEN=$(get_k8s_sa_token "$NAME")
  decode_jwt "$TOKEN"
}

main "$@"
