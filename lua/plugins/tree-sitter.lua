return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'User File',
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
    build = ':TSUpdate',
    config = function()
      require 'module.tree-sitter'
    end,
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = true,
  },
}
