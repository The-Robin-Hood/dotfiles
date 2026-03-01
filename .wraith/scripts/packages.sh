packages_total() {
		total=$(pacman -Qe | wc -l)
    updates=$(checkupdates | wc -l)
    if [ "$updates" -gt 10 ]; then
        text="  $total"
        tooltip="Updates available"
    else
        text="󰏖  $total"
        tooltip="Installed Packages: $total\nNo Updates available"
    fi

    printf '{"text":"%s","tooltip":"%s"}\n' "$text" "$tooltip"

}

show_pkg_info() {
  local pkg="$1"
  pacman -Qi "$pkg" 2>&1 | zenity --text-info \
    --title="Package Info: $pkg" \
    --font="monospace 10"
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
                show_pkg_info "$pkg_name"
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

pkg_update(){

	updates=$(checkupdates | wc -l)

	if [ "$updates" -lt 10 ]; then
		packages_installed_explicitly 
		exit 0
	fi

	zenity --question \
		--title="System Updates Available" \
		--width=600 --height=400 \
		--ok-label="Update" \
		--cancel-label="Ignore" \
		--text="The following updates are available:

		$updates

		Do you want to update now?"

	if [ $? -eq 0 ]; then
		    (
        pkexec pacman -Syu --noconfirm 2>&1 | while read -r line; do
            echo "# $line"
            echo "50"
        done
        echo "100"
    ) | zenity --progress \
        --title="Updating System" \
        --text="Starting update..." \
        --percentage=0 \
        --auto-close
		fi

}


case "$1" in
    "details")
        packages_total
        ;;
		"update")
				pkg_update
				;;
		"")
        packages_installed_explicitly
        ;;
    *)
        echo "Error: Unknown command: $1" >&2
        exit 1
        ;;
esac
