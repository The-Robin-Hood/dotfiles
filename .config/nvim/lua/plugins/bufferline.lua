return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons", "famiu/bufdelete.nvim" },
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers", -- Show buffers (not tabs)
				style_preset = require("bufferline").style_preset.default,
				themable = true,
				numbers = "none", -- Show 1, 2, 3... for easy jumping
				close_command = "bdelete! %d", -- Close buffer command
				right_mouse_command = "bdelete! %d", -- Close with right click
				left_mouse_command = "buffer %d", -- Switch with left click
				middle_mouse_command = nil, -- Nothing on middle click

				-- Visual
				indicator = {
					style = "icon",
				},
				buffer_close_icon = "󰅖",
				modified_icon = "●",
				close_icon = "",
				left_trunc_marker = "",
				right_trunc_marker = "",

				-- Behavior
				max_name_length = 15,
				max_prefix_length = 13,
				truncate_names = true,
				tab_size = 15,
				diagnostics = "nvim_lsp", -- Show LSP diagnostics
				diagnostics_indicator = function(count, level)
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,

				-- Separator style
				separator_style = "thin", -- Options: "slant", "thick", "thin", "padded_slant"

				-- Show/hide elements
				show_buffer_icons = true,
				show_buffer_close_icons = false,
				show_close_icon = false,
				show_tab_indicators = true,
				show_duplicate_prefix = true,
				persist_buffer_sort = true,
				move_wraps_at_ends = false,

				-- Sorting
				sort_by = "insert_after_current",

				-- Custom filtering (optional)
				custom_filter = function(buf_number)
					-- Hide [No Name] buffers
					local name = vim.api.nvim_buf_get_name(buf_number)

					if name == "" then
						return false
					end

					-- Don't show certain filetypes
					local filetype = vim.bo[buf_number].filetype
					if filetype == "qf" or filetype == "help" then
						return false
					end
					return true
				end,
			},
		})
	end,
}
