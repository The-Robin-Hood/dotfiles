# Use Emacs-style keybindings
bindkey -e

# Ctrl + Arrow word navigation
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Character deletion 
bindkey '^?' backward-delete-char # Backspace 
bindkey '^[[3~' delete-char # Delete

# History prefix search with arrow keys
autoload -U up-line-or-beginning-search
zle -N up-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search

autoload -U down-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# Edit command in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

