local lspconfig = require 'lspconfig'
local M = {}

function M.setup(settings)
  -- TODO: cannot complete plugins
  require 'neodev'.setup {
    settings = {
      Lua = {
        workspace = {
          library = {''}
        }
      },
      format = {
        enable = true,
        -- Put format options here
        -- NOTE: the value should be STRING!!
        defaultConfig = {
          indent_style = 'space',
          indent_size = '2',
        },
      },
    },
  }
  lspconfig.sumneko_lua.setup {
    capabilities = settings.capabilities,
    on_attach = settings.on_attach,
  }
end

return M
