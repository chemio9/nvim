---@type LazySpec[]
return {
  {
    'ellisonleao/glow.nvim',
    ft = 'markdown',
    keys = {
      {
        '<localleader>p',
        '<cmd>Glow<CR>',
        noremap = true,
        silent = true,
        desc = 'Preview markdown',
        ft = 'markdown',
      },
    },
    config = true,
  },

  {
    'OXY2DEV/markview.nvim',
    ft = 'markdown',
    cmd = 'Markview',
    keys = {
      {
        '<localleader>t',
        '<cmd>Markview toggleAll<CR>',
        noremap = true,
        silent = true,
        desc = 'Toggle Markview',
        ft = 'markdown',
      },
    },
    config = function()
      local presets = require('markview.presets');

      require('markview').setup({
        modes = { 'n', 'no' },
        buf_ignore = { 'nofile' },

        tables = {
          enable = true,
          use_virt_lines = false,

          text = {},
          hl = {},
        },

        html = {
          enable = true,

          tags = { enable = true },
          entities = { enable = true },
        },
        headings = presets.headings.glow_labels,
      });
    end,
    specs = {
      -- You may not need this if you don't lazy load
      -- Or if the parsers are in your $RUNTIMEPATH
      'nvim-treesitter/nvim-treesitter',

      'nvim-tree/nvim-web-devicons',
    },
  },
}
