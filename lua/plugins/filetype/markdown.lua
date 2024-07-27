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
    opts = {
      buf_ignore = { 'nofile' },
      modes = { 'n', 'no' },
      -- options = {
      --   on_enable = {},
      --   on_disable = {},
      -- },
      -- block_quotes = {},
      -- checkboxes = {},
      -- code_blocks = {},
      -- headings = {},
      -- horizontal_rules = {},
      -- inline_codes = {},
      -- links = {},
      -- list_items = {},
      -- tables = {},
    },

    dependencies = {
      -- You may not need this if you don't lazy load
      -- Or if the parsers are in your $RUNTIMEPATH
      'nvim-treesitter/nvim-treesitter',

      'nvim-tree/nvim-web-devicons',
    },
  },
}
