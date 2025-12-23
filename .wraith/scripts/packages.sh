packages_total() {
    total=$(pacman -Qe | wc -l)
    updates=$(pacman -Qu | wc -l)

    if [ "$updates" -gt 0 ]; then
        text="  $total"
        tooltip="Updates available"
    else
        text="󰏖  $total"
        tooltip="Installed Packages: $total\nNo Updates available"
    fi

    # Output JSON for Waybar
    printf '{"text":"%s","tooltip":"%s"}\n' "$text" "$tooltip"

}


packages_installed_explicitly() {
    out=$(pacman -Qi - < <(
            pacman -Qiqe | awk -F': ' '/^Name/ {name=$2}/^Install Date/ { 
                cmd = "date -d \"" $2 "\" +\"%Y-%m-%d %H:%M:%S\""
                cmd | getline iso
                close(cmd)
                print iso, name
            }' | sort -r | awk '{print $NF}'
        ) | awk -v RS= '
            {
                # Extract fields using Regex from the full text block
                match($0, /Name[[:space:]]*:[[:space:]]*([^\n]*)/, n)
                match($0, /Version[[:space:]]*:[[:space:]]*([^\n]*)/, v)
                match($0, /Description[[:space:]]*:[[:space:]]*([^\n]*)/, d)
                
                name = n[1]
                ver = v[1]
                desc = d[1]

                # Truncate Description
                if (length(desc) > 80) desc = substr(desc, 1, 80) "…"
                
                # Escape Ampersands (Critical for Rofi Pango markup)
                gsub("&", "&amp;", desc)
                gsub("<", "&lt;", desc)
                gsub(">", "&gt;", desc)

                # Output formatted string
                printf "📦 <b>%s</b> (%s)\n<span size=\"small\">%s</span>\x0f", name, ver, desc
            }
        ')
    selected_package_raw=$(printf "%b" "$out" | rofi -dmenu -sep $'\x0f' -eh 2 -i -p "Packages :" -no-show-icons -markup-rows -no-cycle -theme-str 'listview {lines:5;}')

    if [[ -n "$selected_package_raw" ]]; then
        pkg_name=$(echo "$selected_package_raw" | sed -E 's/.*<b>([^<]+)<\/b>.*/\1/' | head -n 1)

        action=$(printf "Info\nUninstall\nCancel" | rofi -dmenu -i -theme $HOME/.wraith/theme/scripts.rofi.rasi -theme-str 'listview {lines:3;}')
        case "$action" in
            "Info")
                smart-launch --tui "Package Info $pkg_name" "bash -c 'pacman -Qi $pkg_name; gum spin --spinner moon --title \"Press any key to close...\" -- bash -c \"read -n 1 -s\"'"
                ;;
            "Uninstall")
                smart-launch --tui "Uninstall Package $pkg_name" "bash -c 'sudo pacman -Rns $pkg_name --noconfirm;  gum spin --spinner moon --title \"Press any key to close...\" -- bash -c \"read -n 1 -s\"'"
                ;;
            *)
                exit 0
                ;;
        esac
    fi

}

case "$1" in
    "details")
        packages_total
        ;;
    "")
        packages_installed_explicitly
        ;;
    *)
        echo "Error: Unknown command: $1" >&2
        exit 1
        ;;
esac