#--------------------------------------------------------------------------------
# EXPORTS
#--------------------------------------------------------------------------------

# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export DEV="$HOME/dev"
export ZSH="$HOME/.oh-my-zsh"
export EDITOR='vim'
export BUN_INSTALL="$HOME/.bun"
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export ANDROID_SWT=/usr/share/java
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export NVM_DIR="$HOME/.nvm"
export FZF_DEFAULT_OPTS="--layout=reverse --height=40%"
export WRAITH_SCRIPTS="$HOME/.wraith/scripts"
export PATH="$PATH:$BUN_INSTALL/bin:$ANDROID_HOME/platform-tools:$JAVA_HOME:$ANDROID_HOME/emulator:$WRAITH_SCRIPTS"
#--------------------------------------------------------------------------------
# SOURCING
#--------------------------------------------------------------------------------

ZSH_THEME="wraith"
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
[ -s "/home/robinhood/.bun/_bun" ] && source "/home/robinhood/.bun/_bun"

#--------------------------------------------------------------------------------
# MISC 
#--------------------------------------------------------------------------------

# Zoxide
eval "$(zoxide init --cmd cd zsh)"

# SSH Configs
[ -f ~/.ssh/github ] && eval "$(keychain -q --eval github)"

#Obsidian Hack - not working with rofi
# if [[ -n "$SSH_AUTH_SOCK" ]]; then
#   sed -i "s|Exec=.*SSH_AUTH_SOCK=[^ ]\\+ /usr/bin/obsidian %U|Exec=SSH_AUTH_SOCK=$SSH_AUTH_SOCK /usr/bin/obsidian %U|" ~/.local/share/applications/obsidian.desktop
# fi

#--------------------------------------------------------------------------------
# ALIAS
#--------------------------------------------------------------------------------

alias cdd="cd $DEV"
alias src="source $HOME/.zshrc"
alias la="ls -a"
alias ccat="bat --color=always"
alias vim=nvim
#--------------------------------------------------------------------------------
# FUNCTIONS
#--------------------------------------------------------------------------------

sync-config() {
  DOTFILES_DIR="$HOME/dotfiles"

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

ff() {
  local files
  files=$(fzf --layout=reverse --multi --preview="bat --color=always {}" --exit-0) || return
  [ -n "$files" ] && vim "${(@f)files}"
}

#--------------------------------------------------------------------------------
