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
local function merge_array(tb)
  for _,v in ipairs(tb) do
    table.insert(plugin,v)
  end
end
merge_array(require 'plugins.cmp.comment')
merge_array(require 'plugins.cmp.luasnip')
merge_array(require 'plugins.cmp.pairs')
return plugin
