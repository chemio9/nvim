local lspconfig = require 'lspconfig'
local M = {}

function M.setup(c)
  lspconfig.emmet_ls.setup {
    on_attach = c,
    filetypes = {
      'css',
      'eruby',
      'html',
      'javascript',
      'javascriptreact',
      'less',
      'sass',
      'scss',
      'svelte',
      'pug',
      'typescriptreact',
      'vue',
    },
    init_options = {
      html = {
        options = {
          ['bem.enabled'] = true,
        },
      },
    },
  }
end

return M
