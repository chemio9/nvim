---@type LazySpec
return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    { 'nvim-telescope/telescope-fzf-native.nvim', enabled = vim.fn.executable 'make' == 1, build = 'make' },
  },
  cmd = 'Telescope',
  config = function()
    require 'module.telescope'
  end,
}
