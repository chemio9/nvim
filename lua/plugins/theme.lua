---@type LazySpec[]
return {
  {
    'EdenEast/nightfox.nvim',
    priority = 1000,
    cond = vim.g.colorscheme == "nightfox",
    opts = {
      options = {
        styles = {             -- Style to be applied to different syntax groups
          comments = 'italic', -- Value is any valid attr-list value `:help attr-list`
          conditionals = 'NONE',
          constants = 'NONE',
          functions = 'NONE',
          types = 'italic,bold',
          keywords = 'italic,bold',
          numbers = 'NONE',
          operators = 'NONE',
          strings = 'NONE',
          variables = 'NONE',
        },
        transparent = false,
        dim_inactive = true,
      },
    },
    config = function (_, opts)
      require("nightfox").setup(opts)
      vim.cmd.colorscheme("nightfox")
    end
  },
}
