---@type LazySpec[]
local plugin = {
  {
    'chenrry666/lsp-setup.nvim',
    branch = 'fix_inlay_hints',
    event = 'BufRead',
    dependencies = {
      'neovim/nvim-lspconfig',
      {
        'williamboman/mason.nvim',
        opts = {
          github = {
            download_url_template = 'https://ghproxy.net/github.com/%s/releases/download/%s/%s',
          },
        },
        cmd = {
          'Mason',
          'MasonInstall',
          'MasonUninstall',
          'MasonUninstallAll',
          'MasonLog',
          'MasonUpdate',
        },
      },
      'williamboman/mason-lspconfig.nvim',

      {
        'folke/neodev.nvim',
        opts = {
          library = {
            types = true,
            plugins = false,
          },
          -- for lazy loading
          -- see before_init
          lspconfig = false,
          setup_jsonls = true,
          pathStrict = true,
        },
      },
    },
    opts = {
      capabilities = require('module.lsp').capabilities,
      on_attach = function(client, bufnr)
        local lsp = require 'module.lsp'
        lsp.on_attach(client, bufnr)
      end,
      inlay_hints = {
        enabled = false,
      },
      servers = {
        -- {{{
        clangd = {
          cmd = {
            'clangd',
            '--compile-commands-dir=build/',
            '--clang-tidy',
            '--all-scopes-completion',
            '--completion-style=bundled',
            '--header-insertion=iwyu',
            '--header-insertion-decorators',
            '--pch-storage=disk',
            '--log=error',
            '--j=4',
            '--background-index',
          },
        },
        lua_ls = {
          before_init = function(...)
            require('neodev.lsp').before_init(...)
          end,
        },
        zls = {
          settings = {
            zls = {
              enable_inlay_hints = true,
              inlay_hints_show_builtin = true,
              inlay_hints_exclude_single_argument = true,
              inlay_hints_hide_redundant_param_names = true,
              inlay_hints_hide_redundant_param_names_last_token = false,
            },
          },
        },
        gopls = {
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
          gofumpt = true,
        },
        tsserver = {},
        emmet_ls = {},
        -- }}}
      },
    },
    config = function(_, opts)
      local lsp = require 'module.lsp'
      lsp.setup_diagnostics()
      require('lsp-setup').setup(opts)
    end,
  },

  {
    'b0o/schemastore.nvim',
    dependencies = {
      {
        'chenrry666/lsp-setup.nvim',
        opts = {
          servers = {
            -- {{{
            jsonls = function()
              return {
                settings = {
                  json = {
                    schemas = require('schemastore').json.schemas(),
                    validate = { enable = true },
                  },
                },
              }
            end,
            yamlls = function()
              return {
                settings = {
                  yaml = {
                    schemaStore = {
                      -- You must disable built-in schemaStore support if you want to use
                      -- this plugin and its advanced options like `ignore`.
                      enable = false,
                      -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                      url = '',
                    },
                    schemas = require('schemastore').yaml.schemas(),
                  },
                },
              }
            end,
            -- }}}
          },
        },
      } },
  },

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

  {
    'jinzhongjia/LspUI.nvim',
    branch = 'main',
    event = 'LspAttach',
    enabled = vim.fn.has('nvim-0.10') == 1,
    cmd = 'LspUI',
    opts = {
      inlay_hint = {
        enable = false,
        command_enable = false,
      },
    },
  },

  {
    'VidocqH/lsp-lens.nvim',
    event = 'LspAttach',
    opts = {},
  },

  {
    'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    enabled = false,
    event = 'LspAttach',
    config = true,
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {},
    },
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
  },
}
return plugin
-- vim: fdm=marker:foldlevel=0
