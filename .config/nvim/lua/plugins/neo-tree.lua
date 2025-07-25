return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons", 
    },
    lazy = false,
	config= function()
		require("neo-tree").setup({
			close_if_last_window = true,
			popup_border_style = "NC",
			enable_git_status = true,
			enable_diagnostics = true,

			window = {
    			position = "right",
				width = 30,
				mappings = {
	      			["l"] = "focus_preview"
				}
			},

			default_component_configs = {
				git_status = {
				symbols = {
					added = "✚",
					modified = "",
					deleted = "✖", 
					renamed = "󰁕", 
					untracked = "󰎔",
					ignored = "",
					unstaged = "󰄱",
					staged = "",
					conflict = "",
					},
				},
			},
			filesystem = {
				follow_current_file = {
					enabled = true,
					},
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = true,
					}
			}
		})
	end

}


