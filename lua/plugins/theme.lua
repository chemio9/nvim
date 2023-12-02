return {
  {
    'EdenEast/nightfox.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      options = {
        styles = {       -- Style to be applied to different syntax groups
          comments = 'italic', -- Value is any valid attr-list value `:help attr-list`
          conditionals = 'NONE',
          constants = 'NONE',
          functions = 'NONE',
          types = "italic,bold",
          keywords = 'italic,bold',
          numbers = 'NONE',
          operators = 'NONE',
          strings = 'NONE',
          variables = 'NONE',
        },
      },
    },
    init = function()
      vim.cmd.colorscheme [[nightfox]]
    end,
  },
}
