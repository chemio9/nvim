local plugin = {
  {
    'neovim/nvim-lspconfig',
    event = 'User File',
    config = function()
      local LspConfigModule = require 'module.lsp'
      local lspconfig = require 'lspconfig'
      LspConfigModule.setup_diagnostics()
      local on_attach = function(client, bufnr)
        require 'lsp_signature'.on_attach({
          bind = true, -- This is mandatory, otherwise border config won't get registered.
          handler_opts = {
            border = 'rounded',
          },
        }, bufnr)
        LspConfigModule.on_attach(client, bufnr)
      end

      lspconfig.util.default_config.capabilities = require 'module.lsp'.capabilities
      for _, config in ipairs { 'clangd', 'lua_ls', 'emmet_ls' } do
        if vim.fn.executable(lspconfig[config].document_config.default_config.cmd[1]) then
          require('module.lsp.' .. config).setup(on_attach)
        end
      end
      for _, config in ipairs {
        -- 'nimls',
        -- 'lemminx',
        'jsonls',
        'cssls',
        'html',
        'tsserver',
      } do
        if vim.fn.executable(lspconfig[config].document_config.default_config.cmd[1]) then
          lspconfig[config].setup {
            capabilities = require 'module.lsp'.capabilities,
            on_attach = on_attach,
          }
        end
      end

      vim.api.nvim_exec_autocmds('FileType', { group = 'lspconfig' })
      require 'core.utils'.event 'LspSetup'
    end,
  },

  { 'ray-x/lsp_signature.nvim' },

  {
    'glepnir/lspsaga.nvim',
    cmd = 'Lspsaga',
    branch = 'main',
    opts = {
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
    },
  },

  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    event = 'User LspSetup',
    opts = {
      window = {
        -- make the fidget background transparent
        blend = 0,
      },
    },
  },

  { 'folke/neodev.nvim' },

  {
    'folke/trouble.nvim',
    cmd = {
      'Trouble',
      'TroubleRefresh',
      'TroubleToggle',
      'TroubleClose',
    },
    opts = {
      use_diagnostic_signs = true,
    },
  },
}
return plugin
