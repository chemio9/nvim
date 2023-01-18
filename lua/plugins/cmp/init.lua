local plugin = {
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      -- Completion sources
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-calc',
      'saadparwaiz1/cmp_luasnip',

      'onsails/lspkind.nvim',
    },
    config = function()
      require 'module.cmp'
    end,
  },
}
---@diagnostic disable: missing-parameter
vim.list_extend(plugin, require 'plugins.cmp.comment')
vim.list_extend(plugin, require 'plugins.cmp.luasnip')
vim.list_extend(plugin, require 'plugins.cmp.pairs')
return plugin
