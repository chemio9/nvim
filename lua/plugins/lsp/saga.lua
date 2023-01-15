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
          colors = {
            normal_bg = '#d1d4cf',
            title_bg = 'NONE',
          },
        },
      }
    end,
  },
}
