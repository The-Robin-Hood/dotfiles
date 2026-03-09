# Completions 
fpath=($ZSH/completions $fpath)
autoload -Uz compinit
compinit
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh_cache

# Prompts
autoload -U colors && colors
PROMPT='%{${fg_bold[blue]}%}%{$fg_bold[green]%}%{$fg[cyan]%}%c%{$fg_bold[red]%} ➜%{$fg_bold[blue]%} % %{$reset_color%}'


eval "$($HOME/.local/bin/mise activate zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(keychain -q --ssh-agent-socket $HOME/.ssh/agent.sock --eval github homelab aur)"

