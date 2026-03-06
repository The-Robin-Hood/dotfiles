#fzf
source <(fzf --zsh)

ZSH_AUTOSUGGEST_DIR="$ZSH/plugins/zsh-autosuggestions"

if [[ ! -d "$ZSH_AUTOSUGGEST_DIR" ]]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_AUTOSUGGEST_DIR"
fi

source "$ZSH_AUTOSUGGEST_DIR/zsh-autosuggestions.zsh"
