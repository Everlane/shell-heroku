#!/bin/bash

if [ -z "$CASED_SHELL_SECRET" ]; then
  echo "CASED_SHELL_SECRET required"
  exit 1
fi

# Configure Cased Shell for Heroku
export CASED_SHELL_PORT=$PORT
export CASED_SHELL_TLS=off
: ${CASED_SHELL_LOG_LEVEL:="error"}
let SSH_PORT=PORT+1 ;
export CASED_SHELL_OAUTH_UPSTREAM=localhost:$SSH_PORT

echo "starting ssh server"
PORT=$SSH_PORT /bin/heroku-ssh heroku http://localhost:$PORT bash -i &

echo "updating port in prompts.json"
jq --arg placeholder SSH_PORT --arg port $SSH_PORT \
  '.prompts | map((select(.port == $placeholder) | .port) |= $port) | { prompts: .}' \
    /prompts.json > /tmp/prompts.json
export CASED_SHELL_HOST_FILE=/tmp/prompts.json

echo "starting cased shell server"
python -u run.py --logging=$CASED_SHELL_LOG_LEVEL &
ps axjf
wait -n