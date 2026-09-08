return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,

			window = {
				position = "right",
				width = 30,
				mappings = {
					["P"] = {
						"toggle_preview",
						config = {
							use_float = true,
							title = "Preview",
						},
					},
				},
			},

			git_status = {
				window = {
					mappings = {
						["gd"] = "git_diff_preview",
					},
				},
				commands = {
					git_diff_preview = function(state)
						local node = state.tree:get_node()
						if node.type ~= "file" then
							vim.notify("Diff only for files", vim.log.levels.ERROR)
							return
						end

						local abs_path = node.path
						local rel_path = vim.fn.fnamemodify(abs_path, ":~:.")

						local dir = vim.fn.fnamemodify(abs_path, ":h")
						vim.fn.system("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --is-inside-work-tree")
						if vim.v.shell_error ~= 0 then
							vim.notify("Not a git repo", vim.log.levels.ERROR)
							return
						end

						-- floating window geometry
						local width = math.floor(vim.o.columns * 0.9)
						local height = math.floor(vim.o.lines * 0.85)
						local row = math.floor((vim.o.lines - height) / 2)
						local col = math.floor((vim.o.columns - width) / 2)

						local buf = vim.api.nvim_create_buf(false, true)
						local win = vim.api.nvim_open_win(buf, true, {
							relative = "editor",
							width = width,
							height = height,
							row = row,
							col = col,
							style = "minimal",
							border = "rounded",
							title = " diff: " .. rel_path .. " ",
							title_pos = "center",
						})

						vim.wo[win].winblend = 0

						vim.fn.termopen(
							"git diff --no-ext-diff --color=always -- "
							.. vim.fn.shellescape(rel_path)
							.. " | delta --side-by-side --paging=always"
						)

						vim.bo[buf].bufhidden = "wipe"
						vim.bo[buf].buflisted = false

						local function close()
							if vim.api.nvim_win_is_valid(win) then
								vim.api.nvim_win_close(win, true)
							end
						end

						vim.keymap.set({ "n", "t" }, "q", close, { buffer = buf, silent = true })
						vim.keymap.set({ "n", "t" }, "<Esc>", close, { buffer = buf, silent = true })

						vim.cmd("startinsert")
					end,
				},
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
				},
			},
			sources = {
				"filesystem",
				"git_status",
			},
			source_selector = {
				winbar = true,
				statusline = false,
			},
		})
	end,
}
