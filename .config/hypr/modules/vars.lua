local home = os.getenv("HOME")
local scripts = home .. "/.wraith/scripts"

return {
	terminal = "uwsm-app -- xdg-terminal-exec",
	fileManager = "smart-launch -n --tui 'file-manager' 'yazi'",
	browser = "librewolf",
	menu = "rofi -show drun",
	cliphistMenu = "cliphist list | rofi -dmenu -p '' -no-show-icons| cliphist decode | wl-copy",
	emojiMenu = "rofimoji -a type copy type-numerical",
	screenshotMenu = scripts .. "/screenshot.sh",
	cycleSpecial = scripts .. "/cycle-special-workspace.sh",
	swaybarToggle = scripts .. "/waybar-swaync.sh",
	swaylock = "swaylock --config " .. home .. "/.config/sway/swaylock.conf",
	handyToggle = "handy --toggle-transcription",
}
