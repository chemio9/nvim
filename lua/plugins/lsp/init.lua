local plugin = {
  {
    'neovim/nvim-lspconfig',
    ft = { 'lua', 'cpp', 'c', 'objc', 'json' },
    config = function()
      local on_attach = function(client, bufnr)
        require 'core.keymap'.attach_lsp(client, bufnr)
      end
      require 'neodev'.setup {}
      local capabilities = require 'cmp_nvim_lsp'.default_capabilities()
      local configs = {
        'clangd',
        'sumneko_lua',
        'vscode-json-language-server',
        -- 'nimlsp',
        -- 'lemminx',
      }
      for _, config in ipairs(configs) do
        require('module.lsp.' .. config).setup {
          capabilities = capabilities,
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
}
---@diagnostic disable: missing-parameter
vim.list_extend(plugin, require 'plugins.lsp.saga')
return plugin
