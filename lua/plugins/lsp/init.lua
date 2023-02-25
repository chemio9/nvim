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
        'lua_ls',
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

  {
    'glepnir/lspsaga.nvim',
    cmd = 'Lspsaga',
    event = 'LspAttach',
    branch = 'main',
    config = function()
      local saga = require 'lspsaga'
      saga.setup {
        lightbulb = {
          enable = true,
          enable_in_insert = true,
          virtual_text = false,
        },
        ui = {
          border = 'rounded',
          colors = {
            normal_bg = 'NONE',
            title_bg = 'NONE',
          },
        },
        symbol_in_winbar = {
          enable = false,
          color_mode = true,
        },
      }
    end,
  },

  {
    'folke/trouble.nvim',
    cmd = {
      "Trouble",
      "TroubleRefresh",
      "TroubleToggle",
      "TroubleClose",
    },
    config = function()
      require 'trouble'.setup {
        use_diagnostic_signs = true,
      }
    end,
  },
}
return plugin
