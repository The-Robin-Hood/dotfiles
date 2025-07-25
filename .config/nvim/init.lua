local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.notify("lazy.nvim not found. Cloning...", vim.log.levels.INFO)

  local result = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })

  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to clone lazy.nvim:\n" .. result, vim.log.levels.ERROR)
    return
  end
end

vim.opt.rtp:prepend(lazypath)

require("keymaps")
require("options")
require("lazy").setup("plugins")

