#!/usr/bin/env zsh

set -euo pipefail

PASSWORD=$(zenity --password --title="Router Login")

JSON=$(tplinkctl -password "$PASSWORD" "/admin/status?form=all" | jq ".data.access_devices_wired + .data.access_devices_wireless_host")
copy() {
    if command -v wl-copy &>/dev/null; then
        printf '%s' "$1" | wl-copy
    else
        printf '%s' "$1" | xclip -selection clipboard
    fi
}

main_menu() {
    echo "$JSON" | jq -r '.[] | "\(.hostname)\t\(.ipaddr)\t\(.macaddr)\t[\(.wire_type)]"'\
        | column -t -s $'\t' \
        | rofi -dmenu -i -p " Devices:" -theme-str 'window {width: 37%;}' -theme-str 'listview {lines:5;}'
}

device_menu() {
    local hostname="$1" ip="$2" mac="$3"
    local action
    action=$(printf "Copy IP: %s\nCopy MAC: %s\n← Back" "$ip" "$mac" \
			| rofi -dmenu -i -theme "$HOME/.wraith/theme/scripts.rofi.rasi" -theme-str 'listview {lines:3;}')

    case "$action" in
        Copy\ IP*)   copy "$ip";  notify-send "Copied IP"  "$ip" ;;
        Copy\ MAC*)  copy "$mac"; notify-send "Copied MAC" "$mac" ;;
        "← Back")    run ;;
        *)           exit 0 ;;
    esac
}

run() {
    local choice hostname ip mac
    choice=$(main_menu) || exit 0
    [[ -z "$choice" ]] && exit 0

    hostname=$(awk '{print $1}' <<< "$choice")
    ip=$(echo "$JSON" | jq -r --arg h "$hostname" '.[] | select(.hostname==$h) | .ipaddr')
    mac=$(echo "$JSON" | jq -r --arg h "$hostname" '.[] | select(.hostname==$h) | .macaddr')

    device_menu "$hostname" "$ip" "$mac"
}

run
