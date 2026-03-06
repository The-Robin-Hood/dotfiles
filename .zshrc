export ZSH="$HOME/.config/zsh"
source $ZSH/exports.zsh

if [[ -o interactive ]]; then
	source $ZSH/options.zsh
	source $ZSH/init.zsh
	source $ZSH/keybinds.zsh 
	source $ZSH/aliases.zsh 
	source $ZSH/plugins.zsh
fi
