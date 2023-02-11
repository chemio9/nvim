local lspconfig = require 'lspconfig'
local M = {}

function M.setup(settings)
  lspconfig.cssls.setup {
    capabilities = settings.capabilities,
    on_attach = settings.on_attach,
  }
end

return M
