alias cdd="cd $DEV"
alias src="source $HOME/.zshrc"
alias la="ls -a"
alias ccat="bat --color=always"
alias decompress="tar -xf"

if command -v eza &> /dev/null; then
  alias ls='eza -lah --group-directories-first --icons=auto --no-user --no-filesize --no-permissions --time-style=long-iso'
  alias lsa='eza -lah --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

if command -v lazygit &> /dev/null; then
	alias lg="lazygit"
fi


#--------------------------------------------------------------------------------
# FUNCTIONS
#--------------------------------------------------------------------------------
open() {
  xdg-open "$@" >/dev/null 2>&1 &
}

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

ff() {
  local files
  files=$(fzf --layout=reverse --multi --preview="bat --color=always {}" --exit-0) || return
  [ -n "$files" ] && vim "${(@f)files}"
}

vim() {
  if [ $# -eq 0 ]; then
    command nvim
    return
  fi

  if [ "$1" = "." ]; then
    command nvim "."
    return
  fi

  if command -v zoxide &> /dev/null; then
    local dir
    dir="$(zoxide query "$1" 2>/dev/null)"
    [ -n "$dir" ] && set -- "$dir" "${@:2}"
  fi

  command nvim "$@"
}


#--------------------------------------------------------------------------------
