return {
  {
    'glepnir/lspsaga.nvim',
    cmd = 'Lspsaga',
    event = 'LspAttach',
    branch = 'main',
    config = function()
      local saga = require 'lspsaga'
      saga.setup {
        lightbulb = {
          enable = true,
          enable_in_insert = true,
          virtual_text = false,
        },
        ui = {
          border = 'rounded',
          colors = {
            normal_bg = 'NONE',
            title_bg = 'NONE',
          },
        },
        symbol_in_winbar = {
          enable = false,
          color_mode = true,
        },
      }
    end,
  },
}
