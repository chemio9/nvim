---@type LazySpec[]
local plugin = {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Completion sources
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-omni',
      'saadparwaiz1/cmp_luasnip',

      'onsails/lspkind.nvim',
    },
    config = function()
      require 'module.cmp'
    end,
  },

  {
    'numToStr/Comment.nvim',
    keys = { { 'gc', mode = { 'n', 'v' } }, { 'gb', mode = { 'n', 'v' } } },
    config = function()
      require 'module.cmp.comment'
    end,
  },

  {
    'L3MON4D3/LuaSnip',
    build = vim.fn.has 'win32' == 0
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
        or nil,
    dependencies = { 'rafamadriz/friendly-snippets' },
    main = 'luasnip',
    config = function()
      require 'module.luasnip'
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require 'module.cmp.pairs'
    end,
  },
}
return plugin
