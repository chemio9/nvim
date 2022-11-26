local plugin = {
    'glepnir/lspsaga.nvim',
    cmd = 'Lspsaga',
    module = 'lspsaga.diagnostic',
    branch = 'main',
}

function plugin.config()
  local saga = require 'lspsaga'
  saga.init_lsp_saga()
end

return plugin
