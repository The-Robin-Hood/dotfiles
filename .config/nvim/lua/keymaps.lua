-- Move lines up/down in normal mode
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==",{})
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==",{})
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv",{})
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv",{})

vim.keymap.set('n', '<Tab>', ':tabnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-b>', ':Neotree toggle<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<S-Tab>', ':tabprevious<CR>', { noremap = true, silent = true })

-- Terminal
vim.keymap.set("n", "<leader>th", ":split | terminal<CR>", { desc = "Terminal horizontal" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to left window" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to lower window" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to upper window" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to right window" })
