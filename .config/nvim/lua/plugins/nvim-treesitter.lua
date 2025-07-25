return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			ensure_installed = { "c","cpp","go",
				"rust","css", "lua", "vim",
				"vimdoc", "javascript", "html",
				"typescript","json","make","cmake",
				"python","yaml","bash"},
			highlight = { enable = true },
			indent = { enable = true }
		})
	end
}
