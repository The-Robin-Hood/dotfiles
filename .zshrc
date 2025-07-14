#--------------------------------------------------------------------------------
# EXPORTS
#--------------------------------------------------------------------------------

# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export DEV="$HOME/dev"
export ZSH="$HOME/.oh-my-zsh"
export EDITOR='vim'

#--------------------------------------------------------------------------------
# OH MY ZSH
#--------------------------------------------------------------------------------

ZSH_THEME="custom-gozilla"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

#--------------------------------------------------------------------------------
# MISC 
#--------------------------------------------------------------------------------

# SSH Configs
eval $(keychain -q --eval github)

#Obsidian Hack
if [[ -n "$SSH_AUTH_SOCK" ]]; then
  sed -i "s|Exec=.*SSH_AUTH_SOCK=[^ ]\\+ /usr/bin/obsidian %U|Exec=SSH_AUTH_SOCK=$SSH_AUTH_SOCK /usr/bin/obsidian %U|" ~/.local/share/applications/obsidian.desktop
fi

#--------------------------------------------------------------------------------
# ALIAS
#--------------------------------------------------------------------------------

alias cdd="cd $DEV"
alias src="source $HOME/.zshrc"
alias la="ls -a"

#--------------------------------------------------------------------------------
# FUNCTIONS
#--------------------------------------------------------------------------------

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

#--------------------------------------------------------------------------------

unalias ls 2>/dev/null

ls() {
  setopt localoptions nullglob

  if [ "$#" -eq 0 ]; then
    command ls -lah --color=always --time-style="+%b %d %H:%M" -d .* * 2>/dev/null \
      | awk '{ printf "%6s %4s %2s %5s  %s\n", $5, $6, $7, $8, substr($0, index($0, $9)) }'
  # elif [ "$#" -eq 1 ] && [ "${1:0:1}" != "-" ] && [ -d "$1" ]; then
  #   command ls -lah -/home/robinhood/.cache/yay/zen-browser/src/pnpm-store-color=always --time-style="+%b %d %H:%M" -d "$1"/.* "$1"/* 2>/dev/null \
  #     | awk '{ printf "%6s %4s %2s %5s  %s\n", $5, $6, $7, $8, substr($0, index($0, $9)) }'
  else
    command ls --color=tty "$@"
  fi
}

#--------------------------------------------------------------------------------
