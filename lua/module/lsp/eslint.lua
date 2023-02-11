local lspconfig = require 'lspconfig'
local M = {}

function M.setup(settings)
  lspconfig.eslint.setup {
    on_attach = function(client, bufnr)
      settings.on_attach(client, bufnr)
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        command = 'EslintFixAll',
      })
    end,
    capabilities = settings.capabilities,
  }
end

return M
