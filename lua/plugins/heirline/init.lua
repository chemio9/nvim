return {
  'rebelot/heirline.nvim',
  event = 'UIEnter',
  config = function()
    local heirline = require 'heirline'
    local colors = require 'tokyonight.colors'.setup()
    heirline.load_colors(colors)
    heirline.setup {
      statusline = require 'plugins.heirline.statusline'.statusline,
      tabline = require 'plugins.heirline.tabline',
    }

    -- Yep, with heirline we're driving manual!
    vim.o.showtabline = 2
    vim.cmd [[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]]
  end,
}
