return {
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
	 		require("telescope.actions")
			require('telescope').setup({
			pickers = {
					find_files = {
						find_command = { "rg", "--files",
							"--hidden","--follow",
							"--glob", "!.git/*",
							"--glob", "!node_modules/*"
							}
						},
					live_grep = {
						additional_args = function()
							return { "--hidden", "--glob", "!.git/*" }
							end,
						}
					}
			})
		end
	},
	{
    'mrloop/telescope-git-branch.nvim',
		config = function()
			require('telescope').load_extension('git_branch')
		end
	},
	{
		'nvim-telescope/telescope-ui-select.nvim',
		config = function()
			require("telescope").setup {
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown {
						}

					}
				}
			}
			require("telescope").load_extension("ui-select")
		end
	}
}
