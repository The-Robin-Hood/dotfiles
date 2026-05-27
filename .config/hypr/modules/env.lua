hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

hl.env("PATH", os.getenv("PATH") .. ":" .. os.getenv("HOME") .. "/.wraith/bin")
hl.env("SSH_AUTH_SOCK", os.getenv("HOME") .. "/.ssh/agent.sock")
hl.env("TERMINAL", "ghostty")
hl.env("EDITOR", "nvim")
