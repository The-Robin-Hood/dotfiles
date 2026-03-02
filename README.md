# dotfiles

Personal dotfiles for an Arch Linux + Hyprland setup, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

| Path | Purpose |
|---|---|
| `.config/hypr/` | Hyprland compositor (keybinds, decorations, idle, lock) |
| `.config/ghostty/` | Ghostty terminal |
| `.config/tmux/` | tmux with Catppuccin theme and TPM |
| `.config/nvim/` | Neovim — lazy.nvim, LSP, Treesitter, Telescope, blink.cmp |
| `.config/waybar/` | Waybar status bar |
| `.config/rofi/` | Rofi launcher with Wraith theme |
| `.config/swaync/` | SwayNC notification center |
| `.config/zsh/` | Zsh aliases, exports, init hooks |
| `.config/ssh/` | Hardened sshd config (key-only auth) |
| `.wraith/scripts/` | Custom shell scripts (brightness, screenshot, packages, etc.) |
| `.wraith/bin/` | Custom binaries (`smart-launch`, `install-app`, `chromium-pwa`, etc.) |
| `.local/share/applications/` | Custom `.desktop` entries for web apps, TUI apps, AppImages |
| `.oh-my-zsh/custom/themes/` | Wraith Zsh prompt theme |
| `.assets/` | Icons, wallpapers, fonts used by the configs |
| `.gitconfig` | Git defaults |
| `.zshrc` | Zsh entry point |

## Requirements

**Core**
- Arch Linux, Hyprland, Zsh + [Oh My Zsh](https://ohmyz.sh/), [GNU Stow](https://www.gnu.org/software/stow/)

**Shell**
- [Ghostty](https://ghostty.org/), [tmux](https://github.com/tmux/tmux) + [TPM](https://github.com/tmux-plugins/tpm)
- [zoxide](https://github.com/ajeetdsouza/zoxide), [fzf](https://github.com/junegunn/fzf), [eza](https://github.com/eza-community/eza), [bat](https://github.com/sharkdp/bat)
- [keychain](https://www.funtoo.org/Keychain), [mise](https://mise.jdx.dev/)

**Wayland**
- [waybar](https://github.com/Alexays/Waybar), [rofi-wayland](https://github.com/lbonn/rofi), [swaync](https://github.com/ErikReider/SwayNotificationCenter)
- [hyprlock](https://github.com/hyprwm/hyprlock), [hypridle](https://github.com/hyprwm/hypridle), [swww](https://github.com/LGFae/swww)
- [cliphist](https://github.com/sentriz/cliphist), [rofimoji](https://github.com/fdw/rofimoji), [gum](https://github.com/charmbracelet/gum)

**Neovim** — Neovim ≥ 0.10, a [Nerd Font](https://www.nerdfonts.com/)

**Brightness** — [ddcutil](https://www.ddcutil.com/) (DDC/CI for external monitors)

## Installation

```sh
git clone https://github.com/The-Robin-Hood/dotfiles ~/dotfiles
cd ~/dotfiles
stow --target="$HOME" .
```

After stowing, open a new shell or run `src` (`source ~/.zshrc`).

**Fix `.desktop` icon paths** — the `.desktop` files under `.local/share/applications/` contain `YOUR_HOME/` as a placeholder for your actual home directory. Run this once after stowing:

```sh
sed -i "s|YOUR_HOME|$HOME|g" ~/.local/share/applications/*.desktop
```

> The `sync-config` shell function re-runs stow whenever you want to apply changes.

## What to update before using

| File | What to change |
|---|---|
| `.gitconfig` | Set your own `name` and `email` under `[user]` |
| `.config/zsh/init.zsh` | Replace `github homelab` with your own SSH key names |
| `.config/hyprpanel/config.json` | `wallpaper.image` — update to your wallpaper path |
| `.config/hypr/modules/vars.conf` | Remove the NVIDIA `env` lines if you don't have an NVIDIA GPU |
| `.config/hypr/modules/windows.conf` | Update the monitor name to match your setup |
| `.local/share/applications/openscad.desktop` | Update the AppImage path under `Exec=` |

## Key bindings

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

## Scripts (`~/.wraith/scripts/`)

| Script | What it does |
|---|---|
| `brightness.sh` | Get/set external monitor brightness via DDC/CI |
| `screenshot.sh` | Region / window / full-screen capture menu |
| `packages.sh` | Browse and uninstall packages; prompts to update |
| `arch-spring-cleanup.sh` | TUI maintenance wizard (upgrade, cache, orphans, logs) |
| `butt-out.sh` | Countdown timer with optional shutdown |
| `display.sh` | Switch monitor input source via DDC |
| `firewall.sh` | UFW setup (run once) |
| `mimetypes.sh` | Set default apps via `xdg-mime` |
| `internet-connectivity.sh` | Outputs network status JSON for Waybar |
| `cycle-special-workspace.sh` | Cycle through Hyprland special workspaces |
| `waybar-swaync.sh` | Restart Waybar and SwayNC |

## Binaries (`~/.wraith/bin/`)

| Binary | What it does |
|---|---|
| `smart-launch` | Focus an existing window or launch a new one (GUI / TUI / web) |
| `install-app` | Interactive installer for web apps, TUI apps, and AppImages |
| `chromium-pwa` | Launch a Chromium PWA with an isolated profile |
| `wdu` | Disk usage summary |
| `swaylock` | Wrapper around swaylock with the configured theme |
