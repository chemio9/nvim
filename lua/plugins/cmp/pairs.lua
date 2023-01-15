return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require 'module.cmp.pairs'
    end,
  },
}
