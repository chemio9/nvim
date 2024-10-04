---@type LazySpec[]
local plugin = {
  {
    'hrsh7th/nvim-cmp',
    -- autopairs will require it, so we don't need to specify events
    -- event = {
    --   'InsertEnter',
    --   -- 'CmdlineEnter',
    -- },
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

      'guilherme-puida/tesoura.nvim',
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
        ['*'] = {
          {
            prefix = 'copyright',
            body = function()
              return 'Copyright (c) ' .. tostring(os.date('%Y') .. ' Chemio9 <chengruichen3@gmail.com>')
            end,
          },
          { prefix = 'date', body = function() return tostring(os.date '%Y-%m-%d') end },
          { prefix = 'now',  body = function() return tostring(os.date '%Y-%m-%d %H:%M:%S') end },
        },
      },
      -- the nvim-cmp source name.
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
    'windwp/nvim-autopairs',
    event = { 'InsertEnter', --[[ 'CmdlineEnter'  ]]},
    config = function()
      require 'module.cmp.pairs'
    end,
  },
}
return plugin
