return {
  {
    'folke/tokyonight.nvim',
    priority = 100, -- load theme first
    opts = {
      style = 'dark',
      sidebars = { 'qf', 'help', 'NvimTree' },
    },
    config = function(_, opts)
      require 'tokyonight'.setup(opts)
      vim.cmd.colorscheme 'tokyonight-night'
    end,
    lazy = false,
  },
}
