-- ── Workspace ─────────────────────────────────────
hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-2", default_name = "AI" })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-2" })
hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-2" })

hl.workspace_rule({ workspace = "4", monitor = "DP-1", default_name = "YT", persistent = true })
hl.workspace_rule({ workspace = "5", monitor = "DP-1", default_name = "Code", persistent = true })
hl.workspace_rule({ workspace = "6", monitor = "DP-1", default_name = "Research", persistent = true })

hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1", default_name = "Communication", persistent = true })

-- ── Window ─────────────────────────────────────

hl.window_rule({
	match = { tag = "floating-window" },
	float = true,
	center = true,
	size = "875 600",
})

local floating_apps = {
	"imv",
	"mpv",
	"nwg-look",
	"localsend",
	"zenity",
	"xdg-desktop-portal-gtk",
	"Termius",
	"rustdesk",
	"com.mitchellh.ghostty",
	"org.telegram.desktop",
	"org.pulseaudio.pavucontrol",
	"org.wraith.*",
	"org.gnome.*",
}

for _, cls in ipairs(floating_apps) do
	hl.window_rule({ match = { initial_class = cls }, tag = "+floating-window" })
end

hl.window_rule({
	match = {
		title =
		"^(Open.*Files?|Open [Ff]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to (?:open|save).*|[Cc]hoose.*)",
	},
	tag = "+floating-window",
})

hl.window_rule({
	match = {
		title =
		"^(Settings|Preferences|Options|About|Help|License|Shortcuts|Keybindings|Update|Updates|Checking for updates|Extensions|Add-ons|Choose a Font|About .*)$",
	},
	tag = "+floating-window",
})

hl.window_rule({
	match = { initial_class = "code|code-oss|Code-Insiders|zenity" },
	workspace = "name:Code",
})

hl.window_rule({
	match = { initial_class = "chrome-gemini\\.google\\.com.*|chrome-claude\\.ai.*|chrome-chatgpt\\.com.*" },
	workspace = "name:AI",
})

hl.window_rule({
	match = { initial_class = "Beeper|org.mozilla.Thunderbird" },
	workspace = "name:Communication silent",
})

hl.window_rule({
	match = { initial_class = "chrome-music\\.youtube\\..*" },
	workspace = "special:music",
})


hl.window_rule({
	match = { title = "^(.*-popup)" }, float = true
})
