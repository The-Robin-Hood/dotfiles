eval "$(zoxide init --cmd cd zsh)"

eval "$(keychain -q --ssh-agent-socket $HOME/.ssh/agent.sock --eval github homelab)"