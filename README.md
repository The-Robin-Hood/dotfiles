# dotfiles

Personal dotfiles for an Arch Linux + Hyprland setup. Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What's inside

| Path | Purpose |
|---|---|
| `.config/hypr/` | Hyprland compositor config (keybinds, windows, decorations, idle, lock) |
| `.config/ghostty/` | Ghostty terminal config |
| `.config/tmux/` | tmux config with Catppuccin theme and TPM plugins |
| `.config/nvim/` | Neovim setup (lazy.nvim, LSP, Treesitter, Telescope, blink.cmp) |
| `.config/waybar/` | Waybar status bar |
| `.config/rofi/` | Rofi launcher with custom Wraith theme |
| `.config/swaync/` | SwayNC notification center |
| `.config/zsh/` | Zsh aliases, exports, init hooks |
| `.config/ssh/` | Hardened sshd config (key-only auth) |
| `.wraith/scripts/` | Shell scripts (brightness, screenshot, packages, cleanup, etc.) |
| `.wraith/bin/` | Custom binaries (`smart-launch`, `install-app`, `chromium-pwa`, etc.) |
| `.local/share/applications/` | Custom `.desktop` entries for web apps, TUI apps, AppImages |
| `.oh-my-zsh/custom/themes/` | Custom `wraith` Zsh prompt theme |
| `.gitconfig` | Git defaults (rebase on pull, histogram diff, auto remote setup) |
| `.zshrc` | Zsh entry point |

## Requirements

**Core**
- Arch Linux
- Hyprland
- Zsh + [Oh My Zsh](https://ohmyz.sh/)
- [GNU Stow](https://www.gnu.org/software/stow/) — `sudo pacman -S stow`

**Terminal / Shell**
- [Ghostty](https://ghostty.org/)
- [tmux](https://github.com/tmux/tmux) + [TPM](https://github.com/tmux-plugins/tpm) (auto-installed on first run)
- [zoxide](https://github.com/ajeetdsouza/zoxide) — smarter `cd`
- [fzf](https://github.com/junegunn/fzf)
- [eza](https://github.com/eza-community/eza) — better `ls`
- [bat](https://github.com/sharkdp/bat) — better `cat`
- [keychain](https://www.funtoo.org/Keychain) — SSH agent manager
- [mise](https://mise.jdx.dev/) — runtime version manager

**Wayland / Desktop**
- [waybar](https://github.com/Alexays/Waybar)
- [rofi-wayland](https://github.com/lbonn/rofi)
- [swaync](https://github.com/ErikReider/SwayNotificationCenter)
- [hyprlock](https://github.com/hyprwm/hyprlock)
- [hypridle](https://github.com/hyprwm/hypridle)
- [swww](https://github.com/LGFae/swww) — wallpaper daemon
- [cliphist](https://github.com/sentriz/cliphist) — clipboard history
- [rofimoji](https://github.com/fdw/rofimoji)
- [gum](https://github.com/charmbracelet/gum) — used by cleanup/package scripts

**Neovim**
- Neovim ≥ 0.10
- A [Nerd Font](https://www.nerdfonts.com/) (config uses Hack Nerd Font Propo)

**Brightness control**
- [ddcutil](https://www.ddcutil.com/) — controls external monitor brightness over DDC/CI

## Installation

```sh
# Clone into your home directory
git clone https://github.com/The-Robin-Hood/dotfiles ~/dotfiles

# Stow everything into $HOME
cd ~/dotfiles
stow --target="$HOME" .
```

After stowing, run `src` (alias for `source ~/.zshrc`) or start a new shell.

> **Tip:** The `sync-config` shell function re-runs stow from `~/dotfiles` whenever you want to apply changes.

## What to change before using

| File | What to update |
|---|---|
| `.gitconfig` | Set your own `name` and `email` under `[user]` |
| `.config/zsh/init.zsh` | Replace `github homelab` in the `keychain` line with your own SSH key names |
| `.config/hyprpanel/config.json` | Update `wallpaper.image` to your preferred wallpaper path |
| `.config/hypr/modules/windows.conf` | Adjust the monitor name (`DP-1`) to match your setup |
| `.config/hypr/modules/vars.conf` | NVIDIA env vars — remove if you don't have an NVIDIA GPU |
| `.config/zsh/exports.zsh` | `DEV` path defaults to `~/dev`, change if needed |
| `.local/share/applications/*.desktop` | These contain absolute icon/exec paths. Re-generate them with `install-app` after stowing so paths match your username |

## Key bindings (Hyprland)

| Key | Action |
|---|---|
| `Super + Space` | App launcher (Rofi) |
| `Super + T` | Terminal (Ghostty) |
| `Super + E` | File manager (Yazi) |
| `Super + B` | Browser (Zen) |
| `Super + L` | Lock screen |
| `Super + V` | Clipboard history |
| `Super + .` | Emoji picker |
| `Super + Shift + S` | Screenshot menu |
| `Super + S` | Cycle special workspaces |
| `Super + Shift + W` | Close window |
| `Super + F` | Toggle floating |
| `Super + Ctrl + F` | Fullscreen |
| `Super + 1–9` | Switch workspace |
| `Super + Shift + 1–9` | Move window to workspace |

## Custom scripts

Located in `~/.wraith/scripts/`:

| Script | What it does |
|---|---|
| `brightness.sh` | Get/set external monitor brightness via DDC/CI |
| `screenshot.sh` | Rofi menu for region, window, or full-screen captures |
| `packages.sh` | Browse/uninstall packages; prompts to update when many updates are pending |
| `arch-spring-cleanup.sh` | TUI maintenance wizard (upgrade, cache, orphans, logs, service health) |
| `butt-out.sh` | Countdown timer that can schedule a shutdown |
| `display.sh` | Switch monitor input source via DDC |
| `internet-connectivity.sh` | Outputs network status JSON for Waybar |
| `firewall.sh` | UFW setup script (run once to configure firewall rules) |
| `mimetypes.sh` | Sets default apps for common file types via `xdg-mime` |
| `cycle-special-workspace.sh` | Cycles through Hyprland special workspaces |
| `waybar-swaync.sh` | Restarts Waybar and SwayNC |

Located in `~/.wraith/bin/`:

| Binary | What it does |
|---|---|
| `smart-launch` | Focus existing Hyprland window or launch a new one (supports GUI, TUI, web apps) |
| `install-app` | Interactive installer for web apps, TUI apps, and AppImages |
| `chromium-pwa` | Chromium wrapper for launching PWAs with isolated profile |
