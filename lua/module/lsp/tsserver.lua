local lspconfig = require 'lspconfig'
local M = {}

function M.setup(settings)
  lspconfig.tsserver.setup {
    capabilities = settings.capabilities,
    on_attach = settings.on_attach,
  }
end

return M
