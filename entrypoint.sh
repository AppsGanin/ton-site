#!/bin/bash
set -x -e -o pipefail

if [[ "${*}" =~ "generate-adnlid" ]]; then
  cd /app/keyring
  generate-random-id -m adnlid
else
  cd /app
  rldp-http-proxy -a $SERVER_IP:$ADNL_PORT -R '*'@$REMOTE_IP:$REMOTE_PORT -C $CONFIG_PATH -A $ADNL
fi
