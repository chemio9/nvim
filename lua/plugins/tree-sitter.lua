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
    dependencies = {
      { 'haringsrob/nvim_context_vt', cmd = { 'NvimContextVtToggle' } },
      { 'p00f/nvim-ts-rainbow', enabled = false },
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    config = true,
  },
  -- }}}
}
