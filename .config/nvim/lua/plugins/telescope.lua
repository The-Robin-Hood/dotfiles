return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local actions = require("telescope.actions")
		require('telescope').setup({
		pickers = {
				find_files = {
					find_command = { "rg", "--files", 
						"--hidden", "--follow",
						"--glob", "!.git/*",
						"--glob", "!node_modules/*"
					}
					}
  			}
		})
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Telescope find files' })
		vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
	end
}
