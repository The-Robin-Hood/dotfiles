packages_total() {
    total=$(pacman -Qe | wc -l)
    updates=$(pacman -Qu | wc -l)
    icon=$([[ $updates -gt 0 ]] && echo "available" || echo "not-available")
    printf '{"pkgs_installed": %d,"pkgs_updatable":%d,"alt":"%s"}\n' "$total" "$updates" "$icon"
}


packages_installed_explicitly() {
    out=$''
    while IFS= read -r pkg; do
        info=$(pacman -Qi -- "$pkg")
        name=$(printf "%s" "$info" | awk -F': ' '/^Name/{print $2}')
        ver=$(printf "%s" "$info" | awk -F': ' '/^Version/{print $2}')
        desc=$(printf "%s" "$info" | awk -F': ' '/^Description/{print $2}')

        short_desc=$(printf "%.80s" "$desc")
        [[ ${#desc} -gt 80 ]] && short_desc="${short_desc}…"

        out+=$'📦  '"<b>$name</b> ($ver)"$'\n'"<span size=\"small\">$short_desc</span>"$'\x0f'

    done < <(pacman -Qqe)
    printf "%b" "$out" | rofi -dmenu -sep $'\x0f' -eh 2 -i -p "Packages :" -no-show-icons -markup-rows -no-cycle
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