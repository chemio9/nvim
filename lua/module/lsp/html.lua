local lspconfig = require 'lspconfig'
local M = {}

function M.setup(settings)
  lspconfig.html.setup {
    capabilities = settings.capabilities,
    on_attach = settings.on_attach,
  }
end

return M
