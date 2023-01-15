return {
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    config = function()
      require 'module.notify'
    end,
  },

  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    config = function()
      require 'module.dressing'
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'UIEnter',
    config = function()
      require 'indent_blankline'.setup {
        -- space_char_blankline = " ",
        -- show_current_context = true,
      }
    end,
  },


}
