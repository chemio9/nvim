local plugin = {
  {
    'neovim/nvim-lspconfig',
    ft = {
      'lua',
      'cpp',
      'c',
      'objc',
      'json',
      'jsonc',
      'html',
      'css',
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    config = function()
      require 'module.lsp'.setup_diagnostics()
      local on_attach = function(client, bufnr)
        require 'lsp_signature'.on_attach({
          bind = true, -- This is mandatory, otherwise border config won't get registered.
          handler_opts = {
            border = 'rounded',
          },
        }, bufnr)
        require 'module.lsp'.on_attach(client, bufnr)
      end
      local configs = {
        'clangd',
        'sumneko_lua',
        'vscode-json-language-server',
        'cssls',
        'html',
        'tsserver',
        'eslint',
        -- 'nimlsp',
        -- 'lemminx',
      }
      for _, config in ipairs(configs) do
        require('module.lsp.' .. config).setup {
          capabilities = require 'module.lsp'.capabilities,
          on_attach = on_attach,
        }
      end
    end,
  },

  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    config = function()
      require 'fidget'.setup {
        window = {
          -- make the fidget background transparent
          blend = 0,
        },
      }
    end,
  },

  { 'folke/neodev.nvim' },

  { 'ray-x/lsp_signature.nvim' },

}
---@diagnostic disable: missing-parameter
vim.list_extend(plugin, require 'plugins.lsp.saga')
return plugin
