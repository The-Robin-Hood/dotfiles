-- Move lines up/down in normal/visual mode
vim.keymap.set("n", "<M-Up>", ":m .-2<CR>==", {})
vim.keymap.set("n", "<M-Down>", ":m .+1<CR>==", {})
vim.keymap.set("v", "<M-Up>", ":m '<-2<CR>gv=gv", {})
vim.keymap.set("v", "<M-Down>", ":m '>+1<CR>gv=gv", {})

vim.keymap.set("n", "<M-Left>", "<C-o>", { desc = "Jump back" })
vim.keymap.set("n", "<M-Right>", "<C-i>", { desc = "Jump forward" })

vim.keymap.set("n", "<Tab>", ":tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-b>", ":Neotree toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", ":tabprevious<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>th", ":split | terminal<CR>", { desc = "Terminal horizontal" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to left window" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to lower window" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to upper window" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to right window" })

vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>f", "<cmd>Telescope live_grep<CR>", { desc = "Telescope live grep " })

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local opts = { buffer = args.buf, silent = true }
		vim.keymap.set("n", "<C-Space>", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<F12>", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<S-F12>", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<A-F12>", vim.lsp.buf.implementation, opts)
	end,
})


-- Jump to buffer by number (like IDE tabs)
vim.keymap.set("n", "<leader>1", ":BufferLineGoToBuffer 1<CR>", { desc = "Go to buffer 1", silent = true })
vim.keymap.set("n", "<leader>2", ":BufferLineGoToBuffer 2<CR>", { desc = "Go to buffer 2", silent = true })
vim.keymap.set("n", "<leader>3", ":BufferLineGoToBuffer 3<CR>", { desc = "Go to buffer 3", silent = true })
vim.keymap.set("n", "<leader>4", ":BufferLineGoToBuffer 4<CR>", { desc = "Go to buffer 4", silent = true })
vim.keymap.set("n", "<leader>5", ":BufferLineGoToBuffer 5<CR>", { desc = "Go to buffer 5", silent = true })
vim.keymap.set("n", "<leader>6", ":BufferLineGoToBuffer 6<CR>", { desc = "Go to buffer 6", silent = true })
vim.keymap.set("n", "<leader>7", ":BufferLineGoToBuffer 7<CR>", { desc = "Go to buffer 7", silent = true })
vim.keymap.set("n", "<leader>8", ":BufferLineGoToBuffer 8<CR>", { desc = "Go to buffer 8", silent = true })
vim.keymap.set("n", "<leader>9", ":BufferLineGoToBuffer 9<CR>", { desc = "Go to buffer 9", silent = true })
vim.keymap.set("n", "<leader>w", ":Bdelete<CR>", {desc = "Delte current buffer"})
