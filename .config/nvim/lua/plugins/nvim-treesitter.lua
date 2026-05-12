-- return {
-- 	"nvim-treesitter/nvim-treesitter",
-- 	build = ":TSUpdate",
-- 	config = function()
-- 		local configs = require("nvim-treesitter.configs")
-- 		configs.setup({
-- 			ensure_installed = { "c", "cpp", "go",
-- 				"rust", "css", "lua", "vim",
-- 				"vimdoc", "javascript", "html",
-- 				"typescript", "json", "make", "cmake",
-- 				"python", "yaml", "bash" },
-- 			indent = { enable = true }
-- 		})
-- 	end
-- }


return {
	"romus204/tree-sitter-manager.nvim",
	config = function()
		require("tree-sitter-manager").setup({
			ensure_installed = {
				"c", "cpp", "go", "rust", "css", "lua",
				"javascript", "typescript", "json",
				"python", "bash", "markdown", "markdown_inline",
			},
			auto_install = true,
		})
	end
}
