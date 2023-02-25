return {
  'rebelot/heirline.nvim',
  event = 'UIEnter',
  config = function()
    vim.opt.laststatus = 3
    vim.opt.showmode = false
    local heirline = require 'heirline'
    local colors = require 'tokyonight.colors'.setup()
    heirline.load_colors(colors)
    heirline.setup {
      statusline = require 'plugins.heirline.statusline',
      tabline = require 'plugins.heirline.tabline',
      winbar = require 'plugins.heirline.winbar',
    }

    vim.o.showtabline = 2
    vim.cmd [[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]]
  end,
}
