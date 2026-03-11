#!/usr/bin/env bash

set -euo pipefail

WALLDIR="${HOME}/.assets/wallpapers"

# ── helpers ──────────────────────────────────────────────────────────────────

die() { echo "error: $*" >&2; exit 1; }

rofi_pick() {
    local title="$1"; shift
    rofi -dmenu -mesg "$title" -theme $HOME/.wraith/theme/scripts.rofi.rasi -theme-str 'listview {lines:5;}' -theme-str 'element-icon { margin: 0px 8px 0px 10px; }' "$@"
}

make_swatch() {
    local color="$1"
    local svg="/tmp/matugen-swatch-${color#'#'}.svg"
    printf '<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32"><rect width="32" height="32" fill="%s"/></svg>' \
        "$color" > "$svg"
    echo "$svg"
}

# ── wallpaper ─────────────────────────────────────────────────────────────────

img_input=""
while IFS= read -r file; do
    img_input+="${file}\0icon\x1f${WALLDIR}/${file}\n"
done < <(find "$WALLDIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -printf "%f\n" | sort)

img=$(printf "%b" "$img_input" | rofi_pick "Choose a wallpaper" -show-icons -theme-str 'listview {orientation: horizontal;columns:2;lines:2;}' -theme-str 'element-icon { size: 200px; margin:0px 10px; padding:0px;}' -theme-str 'element {margin:0px;padding:0px;}' )
img="${WALLDIR}/${img}"

[[ -f "$img" ]] || die "file not found: $img"

# ── scheme ────────────────────────────────────────────────────────────────────

scheme=$(printf '%s\n' \
    tonal-spot expressive fidelity content \
    monochrome neutral rainbow fruit-salad \
    | rofi_pick "Choose a color scheme")
[[ -z "$scheme" ]] && exit 0

# ── seed color ────────────────────────────────────────────────────────────────

RAW=$(echo | script -q -c "matugen image '$img' --dry-run" /dev/stdout 2>/dev/null)
mapfile -t COLORS < <(echo "$RAW" | grep -oP '#[0-9a-fA-F]{6}' | awk '!seen[$0]++')

case "${#COLORS[@]}" in
    0) die "matugen returned no colors" ;;
    1) source_index=0 ;;
    *)
        rofi_input=""
        for color in "${COLORS[@]}"; do
            swatch=$(make_swatch "$color")
            rofi_input+="${color}\0icon\x1f${swatch}\n"
        done

        selected=$(printf "%b" "$rofi_input" | rofi_pick "Pick a seed color" -show-icons)
        [[ -z "$selected" ]] && exit 0

        # find 0-based index
        for i in "${!COLORS[@]}"; do
            [[ "${COLORS[$i]}" == "$selected" ]] && source_index=$i && break
        done
        ;;
esac

# ── apply ─────────────────────────────────────────────────────────────────────

swww img "$img" \
    --transition-fps 60 \
    --transition-type wipe

matugen image "$img" \
    --type "scheme-${scheme}" \
    --source-color-index "$source_index"
