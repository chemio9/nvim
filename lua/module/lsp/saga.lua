local plugin = {
  'glepnir/lspsaga.nvim',
  cmd = 'Lspsaga',
  module = { 'lspsaga.diagnostic', 'lspsaga' },
  event = 'LspAttach',
  branch = 'main',
}

function plugin.config()
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
end

return plugin
