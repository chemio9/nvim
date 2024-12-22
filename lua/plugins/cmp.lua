---@type LazySpec[]
local plugin = {
  {
    'hrsh7th/nvim-cmp',
    event = {
      'InsertEnter',
      -- 'CmdlineEnter',
    },
    dependencies = {
      -- Completion sources
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',

      { url = 'https://codeberg.org/FelipeLema/cmp-async-path' },

      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-omni',
      'f3fora/cmp-spell',

      'lukas-reineke/cmp-under-comparator',

      'onsails/lspkind.nvim',
    },
    config = function()
      require 'module.cmp'
    end,
  },

  {
    'guilherme-puida/tesoura.nvim',
    opts = {
      -- set up autocmd to automatically initialize snippets when a new filetype is opened.
      setup_autocmd = true,
      -- your snippets!
      snippets = {

      },
      -- the nvim_cmp source name.
      source_name = 'tesoura',
    }, -- see the configuration section below.
    config = function(_, opts)
      local tesoura = require('tesoura')
      tesoura.setup(opts)
      tesoura.register_source()
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
    enabled = false,
    build = vim.fn.has 'win32' == 0
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
        or nil,
    dependencies = {
      -- 'rafamadriz/friendly-snippets',
    },
    main = 'luasnip',
    opts = {
      history = true,
      delete_check_events = 'TextChanged',
      region_check_events = 'CursorMoved',
    },
    config = function(_, opts)
      local luasnip = require 'luasnip'
      luasnip.config.setup(opts)
      -- require('module.luasnip')

      luasnip.filetype_extend('cpp', { 'c' })
      luasnip.filetype_extend('javascriptreact', { 'javascript' })
      luasnip.filetype_extend('typescript', { 'javascript' })
      luasnip.filetype_extend('typescriptreact', { 'javascript', 'javascriptreact' })

      vim.schedule(function()
        vim.tbl_map(function(type)
          require('luasnip.loaders.from_' .. type).lazy_load()
        end, { 'vscode', 'snipmate', 'lua' })
      end)
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
