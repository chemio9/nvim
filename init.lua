if vim.loader then vim.loader.enable() end -- enable vim.loader early if available

vim.g.colorscheme = "nightfox"
vim.cmd.packadd[[profile]]
require 'core.options'
require 'core.autocmds'
require 'core.package'

require 'core.keymap'
