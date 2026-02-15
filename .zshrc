# Oh My Zsh Configuration
ZSH_THEME="wraith"
zstyle ':omz:update' mode reminder
plugins=(zsh-autosuggestions)

# Source additional configuration files
source $HOME/.config/zsh/exports.zsh
source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)
source $HOME/.config/zsh/init.zsh
source $HOME/.config/zsh/aliases.zsh 
