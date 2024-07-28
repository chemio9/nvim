---@type LazySpec[]
return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'User File',
    build = function()
      require('nvim-treesitter.install').update({ with_sync = true })()
    end,
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require('lazy.core.loader').add_to_rtp(plugin)
      require('nvim-treesitter.query_predicates')
    end,
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
