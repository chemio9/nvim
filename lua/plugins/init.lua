return {
  --tree-sitter related {{{
  {
    'nvim-treesitter/nvim-treesitter',
    cmd = {
      'TSBufDisable',
      'TSBufEnable',
      'TSBufToggle',
      'TSDisable',
      'TSEnable',
      'TSToggle',
      'TSInstall',
      'TSInstallInfo',
      'TSInstallSync',
      'TSModuleInfo',
      'TSUninstall',
      'TSUpdate',
      'TSUpdateSync',
    },
    build = function()
      require 'nvim-treesitter.install'.update { with_sync = true } ()
    end,
    config = function()
      require 'module.tree-sitter'
    end,
    commit = '3cb75be',
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'UIEnter',
    config = function()
      require 'treesitter-context'.setup {}
    end,
    dependencies = {
      'p00f/nvim-ts-rainbow',
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
  },
  -- }}}

  {
    'akinsho/toggleterm.nvim',
    -- tag = '*',
    cmd = {
      'ToggleTerm',
      'ToggleTermToggleAll',
      'ToggleTermSetName',
      'ToggleTermSendVisualLines',
      'ToggleTermSendVisualSelection',
    },
    config = function()
      require 'toggleterm'.setup {}
    end,
  },

  {
    'kylechui/nvim-surround',
    keys = { 'ys', 'ds', 'cs' },
    -- tag = '*', -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require 'nvim-surround'.setup {}
    end,
  },
  -- window managing
  {
    'mrjones2014/smart-splits.nvim',
    config = function()
      require 'module.smart-splits'
    end,
  },

  {
    'max397574/better-escape.nvim',
    event = 'InsertCharPre',
    config = function()
      require 'better_escape'.setup {}
    end,
  },

  {
    'folke/zen-mode.nvim',
    config = function()
      require 'zen-mode'.setup {
        window = {
          backdrop = 1,
        },
      }
    end,
  },

  { 'nvim-lua/plenary.nvim', lazy = true },

  {
    'sindrets/diffview.nvim',
    config = function()
      require 'diffview'.setup {}
    end,
  },

  {
    'folke/neodev.nvim',
    ft = 'lua',
  },

  {
    'ray-x/lsp_signature.nvim',
    event = 'LspAttach',
    config = function()
      require 'lsp_signature'.setup()
    end,
  },

  {
    'goolord/alpha-nvim',
    config = function()
      require 'module.alpha'
    end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    tag = 'nightly', -- updated every week. (issue #1193)
    config = function()
      require 'module.tree'
    end,
  },

  { 'nvim-tree/nvim-web-devicons', lazy = true }, -- for file icons

  'jghauser/mkdir.nvim',

}
-- vim: fdm=marker
