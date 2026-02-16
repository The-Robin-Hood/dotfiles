vim.g.mapleader = " "

vim.diagnostic.config({
  virtual_text = {
    prefix = "",
    spacing = 2,
  },
  signs = true,
  underline = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})


local opt = vim.opt

-- ============================================
-- INTERFACE & APPEARANCE
-- ============================================
opt.number = true                    -- Show line numbers
opt.cursorline = true                -- Highlight current line
opt.signcolumn = "yes"               -- Always show sign column (git, diagnostics)
opt.ruler = false                    -- Hide ruler (statusline shows this)
opt.showmode = false                 -- Hide mode indicator (statusline shows this)
opt.laststatus = 3                   -- Global statusline
opt.termguicolors = true             -- Enable 24-bit RGB colors
opt.pumblend = 10                    -- Popup menu transparency (10%)
opt.pumheight = 10                   -- Maximum popup menu height
opt.conceallevel = 2                 -- Conceal text with replacements (markdown, etc.)
opt.shortmess:append("I")            -- Don't show intro message

-- ============================================
-- INDENTATION & FORMATTING
-- ============================================
opt.shiftwidth = 2                   -- Indent width (2 spaces)
opt.tabstop = 2                      -- Tab width (2 spaces)
opt.shiftround = true                -- Round indent to multiple of shiftwidth
opt.smartindent = true               -- Smart auto-indenting
opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt"       -- Auto-formatting options

-- ============================================
-- SEARCH & NAVIGATION
-- ============================================
opt.ignorecase = true                -- Case-insensitive search...
opt.smartcase = true                 -- ...unless uppercase is used
opt.inccommand = "nosplit"           -- Live preview of :s substitutions
opt.grepformat = "%f:%l:%c:%m"       -- Grep output format
opt.grepprg = "rg --vimgrep"         -- Use ripgrep for :grep

-- ============================================
-- SCROLLING & DISPLAY
-- ============================================
opt.scrolloff = 4                    -- Keep 4 lines above/below cursor
opt.sidescrolloff = 8                -- Keep 8 columns left/right of cursor
opt.wrap = false                      -- Wrap long lines

-- ============================================
-- SPLITS & WINDOWS
-- ============================================
opt.splitbelow = true                -- Horizontal splits open below
opt.splitright = true                -- Vertical splits open right

-- ============================================
-- FILES & PERSISTENCE
-- ============================================
opt.undofile = true                  -- Persistent undo across sessions
opt.undolevels = 10000               -- Maximum undo history

-- ============================================
-- INPUT & INTERACTION
-- ============================================
opt.mouse = "a"                      -- Enable mouse support
opt.confirm = true                   -- Ask for confirmation instead of failing
opt.clipboard:append("unnamedplus")  -- Use system clipboard

-- ============================================
-- PERFORMANCE
-- ============================================
opt.updatetime = 200                 -- Faster CursorHold events (ms)
opt.timeoutlen = 500                 -- Key sequence timeout (ms)

-- ============================================
-- FOLDING
-- ============================================
opt.foldlevel = 99                   -- Start with all folds open

-- ============================================
-- TERMINAL INTEGRATION
-- ============================================
opt.title = true                     -- Set terminal title
opt.titlestring = "%{expand('%:t')}" -- Title = current filename
