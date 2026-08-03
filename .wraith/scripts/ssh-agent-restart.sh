#!/usr/bin/env zsh

PRIVATE_KEY_DIR="${HOME}/.ssh/private"
AGENT_SOCK="${HOME}/.ssh/agent.sock"

keychain agent stop --mine

rm -f "${AGENT_SOCK}"

eval "$(keychain add \
  --ssh-agent-socket "$AGENT_SOCK" \
  --eval \
  "$PRIVATE_KEY_DIR"/* \
  --immediate --quiet)"
