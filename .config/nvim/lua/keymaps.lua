-- Move lines up/down in normal mode
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==",{})
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==",{})
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv",{})
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv",{})

vim.keymap.set('n', '<Tab>', ':tabnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-b>', ':Neotree toggle<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<S-Tab>', ':tabprevious<CR>', { noremap = true, silent = true })
