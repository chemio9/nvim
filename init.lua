if vim.loader then vim.loader.enable() end -- enable vim.loader early if available

require 'core.options'
require 'core.autocmds'
require 'core.package'

require 'core.keymap'

vim.cmd.colorscheme[[tokyonight]]
