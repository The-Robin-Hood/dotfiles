hl.on("hyprland.start", function()
	hl.exec_cmd("hyprctl setcursor ArcStarry 25")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
	hl.exec_cmd("waybar")
	hl.exec_cmd("swaync")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("awww-daemon")

	hl.exec_cmd("keychain add --ssh-agent-socket '/home/robin/.ssh/agent.sock' --eval github homelab aur --immediate")

	-- autostart applications
	hl.exec_cmd("$(awk -F= '/^Exec/ {print $2; exit}' ~/.local/share/applications/Beeper.desktop)")
	hl.exec_cmd("thunderbird")


	hl.timer(function()
		hl.dispatch(hl.dsp.focus({workspace ="5"}))
	end,{timeout= 1500,type="oneshot"})
end)
