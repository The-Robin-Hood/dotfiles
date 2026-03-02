eval "$(zoxide init --cmd cd zsh)"

# Replace 'github homelab' with the names of your SSH keys in ~/.ssh/
eval "$(keychain -q --ssh-agent-socket $HOME/.ssh/agent.sock --eval github homelab)"

eval "$($HOME/.local/bin/mise activate zsh)"
