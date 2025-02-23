---@type LazySpec[]
return {
  {
    'Exafunction/codeium.nvim',
    event = 'InsertEnter',
    enabled = false,
    specs = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('codeium').setup {}
    end,
  },
}
