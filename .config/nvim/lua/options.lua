vim.g.mapleader = " "

local opt = vim.opt

opt.shortmess:append("I")
opt.shiftwidth = 2
opt.tabstop = 2
opt.shiftround = true
opt.smartindent = true
opt.autowrite = true
opt.conceallevel = 2
opt.confirm = true
opt.cursorline = true
opt.ignorecase = true
opt.smartcase = true
opt.linebreak = true
opt.number = true
opt.relativenumber = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.timeoutlen = vim.g.vscode and 1000 or 300

opt.foldlevel = 99
opt.signcolumn = "yes"
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.inccommand = "nosplit"
opt.laststatus = 3
opt.mouse = "a"
opt.termguicolors = true
opt.pumblend = 10
opt.pumheight = 10
opt.wrap = false

opt.ruler = false
opt.showmode = false
