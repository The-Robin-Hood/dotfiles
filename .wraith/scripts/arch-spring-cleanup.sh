#!/usr/bin/env zsh
# ============================================================================
# Arch Linux Maintenance TUI
# ============================================================================

center_box() {
  local content="$1"
  local term_width box_width pad

  term_width=$(tput cols)
  
  # Get the width of the content (rough estimate)
  box_width=$(echo "$content" | wc -L)
  
  pad=$(( (term_width - box_width) / 2 ))
  (( pad < 0 )) && pad=0

  # Add left padding to each line of the box
  echo "$content" | while IFS= read -r line; do
    printf "%*s%s\n" "$pad" "" "$line"
  done
}

cleanup() {
  echo ""
  tput cnorm 2>/dev/null || true
  show_header
  gum style --foreground "$MOCHA_RED" --bold "Operation cancelled by user."
  sub_text "Press any key to exit..."
  read -n 1
  exit 130
}

gum_safe() {
  local resultCode
  gum "$@"
  resultCode=$?

  if (( resultCode == 130 )); then
    cleanup
  elif (( resultCode != 0 )); then
    return $resultCode
  fi
}


# -------------------------------------

export MOCHA_MAUVE="#cba6f7"
export MOCHA_LAVENDER="#b4befe"
export MOCHA_GREEN="#a6e3a1"
export MOCHA_RED="#f38ba8"
export MOCHA_TEXT="#cdd6f4"
export MOCHA_OVERLAY="#6c7086"
export MOCHA_BASE="#1e1e2e"

# -- Gum Defaults --
export GUM_SPIN_SPINNER="dot"
export GUM_SPIN_SPINNER_FOREGROUND="$MOCHA_LAVENDER"
export GUM_SPIN_TITLE_FOREGROUND="$MOCHA_TEXT"
export GUM_CONFIRM_PROMPT_FOREGROUND="$MOCHA_MAUVE"
export GUM_CONFIRM_SELECTED_BACKGROUND="$MOCHA_MAUVE"
export GUM_CONFIRM_SELECTED_FOREGROUND="$MOCHA_BASE"
export GUM_CONFIRM_UNSELECTED_FOREGROUND="$MOCHA_OVERLAY"
export GUM_STYLE_BORDER="double"
export GUM_STYLE_BORDER_FOREGROUND="$MOCHA_MAUVE"
export GUM_STYLE_FOREGROUND="$MOCHA_TEXT"

# -------------------------------------
# Dependency Checks
# -------------------------------------

LOG_DIR="$HOME/.local/var/log"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/maintenance-$(date +%F_%H-%M-%S).log"

AUR_HELPER="yay"

if ! command -v gum &>/dev/null || ! command -v yay &>/dev/null || ! command -v paccache &>/dev/null; then
  command -v gum &>/dev/null || { echo "❌ Error: 'gum' is not installed. Please install it to proceed."; exit 1; }
  command -v yay &>/dev/null || { gum style --foreground "$MOCHA_RED" "❌ Error: No AUR helper (paru/yay) found."; exit 1; }
  command -v paccache &>/dev/null || { gum style --foreground "$MOCHA_RED" "❌ Error: 'pacman-contrib' is missing." "Install it with: sudo pacman -S pacman-contrib"; exit 1; }
fi

show_header() {
  clear
  header=$(gum_safe style \
    --align "center" \
    --border "double" \
    --margin "1" \
    --padding "1 2" \
    --border-foreground "$MOCHA_MAUVE" \
    "☕ Arch Linux Spring-Clean"
  )
  center_box "$header"
}

run_task() {
  local label="$1"
  local cmd="$2"
  
  if gum_safe spin --title "$label" -- sh -c "$cmd >> $LOG_FILE 2>&1"; then
    gum_safe style --foreground "$MOCHA_GREEN" --border none "✓ $label completed"
  else
    gum_safe style --foreground "$MOCHA_RED" --border none "✗ $label failed! Check logs."
  fi
}

section_title() {
  echo ""
  gum_safe style --foreground "$MOCHA_MAUVE" --bold --border none "$1"
}

sub_text() {
  gum_safe style --foreground "$MOCHA_OVERLAY" --border none "$1"
}

# -------------------------------------
#  Execution
# -------------------------------------

show_header

# get sudo upfront
if ! sudo -v; then
  gum_safe style --foreground "$MOCHA_RED" "❌ Error: Sudo authentication failed."
  exit 1
fi

# --- Step 1 ---
section_title "1. System Upgrade"
if gum_safe confirm "Upgrade system packages?"; then
  $AUR_HELPER -Syu
else
  sub_text "Skipped upgrade."
fi

# --- Step 2 ---
section_title "2. Pacman Cache"
current_pkg_cache=$(du -sh /var/cache/pacman/pkg 2>/dev/null | cut -f1)

if gum_safe confirm "Clean pacman cache? (Current: $current_pkg_cache)"; then
  run_task "Pruning package cache" "sudo paccache -vrk 2 && sudo paccache -ruk0"
else
  sub_text "Skipped package cache."
fi

# --- Step 3 ---
section_title "3. Orphaned Packages"
ORPHANS=$($AUR_HELPER -Qtdq)

if [[ -z "$ORPHANS" ]]; then
  gum_safe style --foreground "$MOCHA_GREEN" --border none "✓ No orphaned packages found."
else
  gum_safe style --foreground "$MOCHA_PEACH" --border none "Found orphaned packages:"
  echo "$ORPHANS" | gum_safe format

  if gum_safe confirm "Remove orphaned packages?"; then
    run_task "Removing orphaned packages" "sudo pacman -Rns $ORPHANS"
  else
    sub_text "Skipped orphan removal."
  fi
fi

# --- Step 4 ---
section_title "4. User Cache"
sub_text "Targets: thumbnails, yay, paru, pip, npm"

LARGE_CACHES=(${(f)"$(du -d 1 -h ~/.cache 2>/dev/null | grep -E '^([5-9][0-9][0-9]M|[0-9]+(\.[0-9]+)?G)' | grep -vE "\.cache$")"})

if [[ ${#LARGE_CACHES[@]} -eq 0 ]]; then
    sub_text "Everything is clean! No folders > 500MB."
else
    SELECTED=$(printf "%s\n" "${LARGE_CACHES[@]}" | gum choose --no-limit --header "Select caches to wash")

    if [[ -z "$SELECTED" ]]; then
        sub_text "Skipped user cache."
    else
        echo "$SELECTED" | while read -r line; do
            TARGET_PATH=$(echo "$line" | awk '{print $2}')
            if [[ -d "$TARGET_PATH" ]]; then
                run_task "Cleaning ${TARGET_PATH}" "rm -rf ${TARGET_PATH:?}/*"
            fi
        done
    fi
fi

# --- Step 5 ---
section_title "5. System Logs"
current_journal=$(journalctl --disk-usage | awk '{print $NF}')

if gum_safe confirm "Vacuum logs > 7d? (Current: $current_journal)"; then
  run_task "Rotating logs" "sudo journalctl --rotate"
  run_task "Vacuuming logs" "sudo journalctl --vacuum-time=7d"
else
  sub_text "Skipped logs."
fi

# --- Step 6 ---
section_title "6. Service Health"
failed_count=$(systemctl list-units --state=failed --no-legend | wc -l)

if (( failed_count == 0 )); then
  gum_safe style --foreground "$MOCHA_GREEN" --border none "✓ All systems operational."
else
  gum_safe style --foreground "$MOCHA_RED" --border none "⚠️  $failed_count services failed:"
  systemctl --failed --no-pager --plain | gum_safe format
fi

echo ""
gum_safe style --padding "1" "✨ Maintenance Complete."
gum_safe style --foreground "$MOCHA_GREEN" --bold "Review the log at: $LOG_FILE"
gum spin --spinner "moon" --title "Press any key to close..." -- bash -c 'read -n 1 -s'
