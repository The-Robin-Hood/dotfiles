#!/usr/bin/env zsh
# ============================================================================
# Arch Linux "Spring‑Clean" Maintenance Script
# ============================================================================

set -euo pipefail
trap 'echo "[!] Script aborted by user."; exit 1' INT TERM

# -------------------------------------
# 0: Detect AUR helper (paru or yay)
# -------------------------------------

if command -v paru &>/dev/null; then
  AUR=paru
elif command -v yay &>/dev/null; then
  AUR=yay
else
  echo "Error: You need to install either 'paru' or 'yay' to use this script." >&2
  exit 1
fi

# -------------------------------------
# 1: Set up logging and configuration
# -------------------------------------

LOG_DIR="$HOME/.local/var/log"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/spring-clean-$(date +%F_%H-%M-%S).log"

PACCACHE_RETAIN=2     # Keep only the latest 2 versions of packages
CACHE_DAYS=30         # Delete ~/.cache files older than 30 days
JOURNAL_RETAIN="7d"   # Keep only 7 days of system logs

exec > >(tee -a "$LOG_FILE") 2>&1  # Everything goes to log file AND terminal

# -------------------------------------
# Helper functions
# -------------------------------------

confirm() {
  read -r -p "${1:-Are you sure? [y/N]} " ans
  [[ "$ans" =~ ^([yY][eE][sS]|[yY])$ ]]
}

announce() {
  printf "\n\e[1;32m🔹 %s\e[0m\n" "$1"
}

step() {
  printf "\n\e[1;34m==> %s\e[0m\n" "$1"
}

# -------------------------------------
# Optional: Check for --upgrade flag
# -------------------------------------

DO_UPGRADE=false
while [[ $# -gt 0 ]]; do
  case $1 in
    -u|--upgrade) DO_UPGRADE=true; shift ;;
    -h|--help)
      echo "Usage: $0 [--upgrade]"
      echo "       --upgrade   Also upgrade all system and AUR packages"
      exit 0 ;;
    *) echo "Unknown option: $1" ; exit 2 ;;
  esac
done

announce "Arch Linux Spring‑Clean Starting — Using AUR Helper: $AUR"
echo "Log file saved to: $LOG_FILE"

# -------------------------------------
# 2: Optional System Upgrade
# -------------------------------------

if $DO_UPGRADE; then
  step "UPGRADING SYSTEM PACKAGES"
  echo "This will update all official and AUR packages."
  if confirm "Continue with system upgrade? [y/N]"; then
    $AUR -Syu --ask 4
    echo "NOTE: After upgrade, run: sudo pacdiff — to handle .pacnew files."
  else
    echo "Skipped system upgrade."
  fi
fi

# -------------------------------------
# 3: Clean Pacman Cache
# -------------------------------------

step "CLEANING PACKAGE CACHE"
current_cache=$(du -sh /var/cache/pacman/pkg | cut -f1)
echo "Current cache size: $current_cache"

if confirm "Clean old package cache (keep last $PACCACHE_RETAIN)? [y/N]"; then
  sudo paccache -vrk $PACCACHE_RETAIN
  sudo paccache -ruk0
  new_cache=$(du -sh /var/cache/pacman/pkg | cut -f1)
  echo "New cache size: $new_cache"
else
  echo "Skipped cache cleanup."
fi

# -------------------------------------
# 4: Remove Orphaned Packages
# -------------------------------------

step "REMOVING UNUSED (ORPHANED) PACKAGES"
mapfile -t ORPHANS < <($AUR -Qtdq)
if ((${#ORPHANS[@]})); then
  echo "Found ${#ORPHANS[@]} orphaned packages:"
  printf '%s\n' "${ORPHANS[@]}"
  if confirm "Remove these unneeded packages? [y/N]"; then
    sudo pacman -Rns "${ORPHANS[@]}"
  else
    echo "Skipped removing orphans."
  fi
else
  echo "No orphaned packages found. All clean!"
fi

# -------------------------------------
# 5: Prune ~/.cache (user cache)
# -------------------------------------

step "CLEANING ~/.cache DIRECTORY"
before_cache=$(du -sh ~/.cache | cut -f1)
echo "Cache size before cleanup: $before_cache"

if confirm "Delete files older than $CACHE_DAYS days from ~/.cache? [y/N]"; then
  find ~/.cache -type f -mtime +$CACHE_DAYS -print -delete
  find ~/.cache -type d -empty -print -delete
  after_cache=$(du -sh ~/.cache | cut -f1)
  echo "Cache size after cleanup: $after_cache"
else
  echo "Skipped cleaning ~/.cache."
fi

# -------------------------------------
# 6: Clean old system logs (journald)
# -------------------------------------

step "VACUUMING SYSTEM LOGS (journald)"
before_logs=$(journalctl --disk-usage | awk '{print $NF}')
echo "Current journal size: $before_logs"

if confirm "Delete logs older than $JOURNAL_RETAIN? [y/N]"; then
  sudo journalctl --rotate
  sudo journalctl --vacuum-time=$JOURNAL_RETAIN
  after_logs=$(journalctl --disk-usage | awk '{print $NF}')
  echo "Journal size after vacuum: $after_logs"
else
  echo "Skipped journald cleanup."
fi

# -------------------------------------
# 7: Check for Failed Services
# -------------------------------------

step "CHECKING FOR FAILED SYSTEMD SERVICES"
if systemctl --failed --quiet; then
  echo "✅ No failed services found."
else
  echo "⚠️ Some services have failed:"
  systemctl --failed --no-pager --plain
fi

# -------------------------------------
# Finished
# -------------------------------------

announce "✅ Spring‑Clean Completed in ${SECONDS}s"
echo "Full log saved to: $LOG_FILE"

# -------------------------------------
