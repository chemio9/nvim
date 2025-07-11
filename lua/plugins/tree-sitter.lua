---@type LazySpec[]
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    config = function()
      require 'module.tree-sitter'
    end,
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = true,
  },
}
