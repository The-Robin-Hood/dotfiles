#!/bin/zsh

OPTIONS=(
    "📸 Capture region"
    "📋 Capture region (to clipboard)"
    "🪟 Capture active window"
    "🖥️ Capture full screen"
    "📂 Open screenshots folder"
    "🧹 Clear screenshots folder"
)

# Show rofi menu and get selected option
CHOICE=$(printf "%s\n" "${OPTIONS[@]}" | rofi -dmenu -i -p "Screenshot Menu" -theme $HOME/.wraith/theme/scripts.rofi.rasi -theme-str 'listview {lines:6;}' 2>/dev/null)

SCREENSHOT_DIR=$HOME/desktop/screenshots
mkdir -p "$SCREENSHOT_DIR"  # Ensure directory exists

case "$CHOICE" in
    "📸 Capture region")
        hyprshot -m region -o "$SCREENSHOT_DIR" && \
        notify-send "Screenshot Taken" "Region saved to $SCREENSHOT_DIR"
        ;;
    "📋 Capture region (to clipboard)")
        hyprshot -m region --clipboard-only && \
        notify-send "Screenshot Copied" "Region copied to clipboard"
        ;;
    "🪟 Capture active window")
        hyprshot -m window -m active -o "$SCREENSHOT_DIR" && \
        notify-send "Screenshot Taken" "Window saved to $SCREENSHOT_DIR"
        ;;
    "🖥️ Capture full screen")
        hyprshot -m output -o "$SCREENSHOT_DIR" && \
        notify-send "Screenshot Taken" "Full screen saved to $SCREENSHOT_DIR"
        ;;
    "📂 Open screenshots folder")
        xdg-open "$SCREENSHOT_DIR" &>/dev/null
        ;;
    "🧹 Clear screenshots folder")
        rm -i "$SCREENSHOT_DIR"/* && \
        notify-send "Screenshots Cleared" "All files deleted from $SCREENSHOT_DIR"
        ;;
esac