return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.goimports,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.gdformat,
				null_ls.builtins.diagnostics.gdlint,
			},
		})
		vim.keymap.set("n", "<C-S-I>", vim.lsp.buf.format, {})
	end,
}
