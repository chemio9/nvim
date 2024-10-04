---@type LazySpec[]
return {
  {
    '0xstepit/flow.nvim',
    cond = vim.g.colorscheme == "flow",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require('flow').setup {
        dark_theme = true,      -- Set the theme with dark background.
        high_contrast = false,  -- Make the dark background darker or the light background lighter.
        transparent = true,    -- Set transparent background.
        fluo_color = 'pink',    -- Color used as fluo. Available values are pink, yellow, orange, or green.
        mode = 'bright',          -- Mode of the colors. Available values are: dark, bright, desaturate, or base.
        aggressive_spell = false, -- Use colors for spell check.
      }
      vim.cmd.colorscheme("flow")
    end
  },
  {
    'EdenEast/nightfox.nvim',
    priority = 1000,
    lazy = false,
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
