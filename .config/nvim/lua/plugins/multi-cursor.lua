return {
	"mg979/vim-visual-multi",
	branch = "master",
	event = "VeryLazy",
	init = function()
		vim.g.VM_maps = {
			["Find Under"] = "<C-d>", -- Select word and add next occurrence
			["Find Subword Under"] = "<C-d>", -- Same for subwords
			["Find Next"] = "<C-d>", -- Continue adding next occurrence

			["Add Cursor Down"] = "<C-M-Down>",
			["Add Cursor Up"] = "<C-M-Up>",
			["Add Cursor At Pos"] = "<M-LeftMouse>",

			["Visual Cursors"] = "<C-d>", -- Add cursor on each line in visual
			["Insert Mode"] = "i",
			["Append Mode"] = "a",
			["Visual Mode"] = "v",
		}

		-- Settings
		vim.g.VM_theme = "iceblue"
		vim.g.VM_highlight_matches = "red"
	end,
}
