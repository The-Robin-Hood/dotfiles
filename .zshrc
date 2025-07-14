# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export DEV="$HOME/dev"
export ZSH="$HOME/.oh-my-zsh"

alias cdd="cd $DEV"

ZSH_THEME="robbyrussell"

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh
export EDITOR='vim'

# SSH Configs
eval $(keychain -q --eval github)

#Obsidian Hack
if [[ -n "$SSH_AUTH_SOCK" ]]; then
  sed -i "s|Exec=.*SSH_AUTH_SOCK=[^ ]\\+ /usr/bin/obsidian %U|Exec=SSH_AUTH_SOCK=$SSH_AUTH_SOCK /usr/bin/obsidian %U|" ~/.local/share/applications/obsidian.desktop
fi


sync-config() {
  DOTFILES_DIR="$HOME/dev/.dotfiles"

  echo "⚠️  This will sync all dotfiles from:"
  echo "    $DOTFILES_DIR --> $HOME"
  echo
  read "reply?Proceed with sync? [y/N]: "

  if [[ "$reply" =~ ^[Yy]$ ]]; then
    echo "🔄 Syncing..."
    cd "$DOTFILES_DIR" || { echo "❌ Failed to change directory"; return 1; }
    stow --target="$HOME" .
    echo "✅ Dotfiles synced."
  else
    echo "❌ Sync cancelled."
  fi
}