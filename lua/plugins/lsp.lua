---@type LazySpec[]
local plugin = {
  {
    -- TODO: use my own fork of lsp-setup or just rewrite it
    'chenrry666/lsp-setup.nvim',
    branch = 'fix_inlay_hints',
    event = 'BufRead',
    dependencies = {
      'neovim/nvim-lspconfig',
      {
        'williamboman/mason.nvim',
        opts = {
          github = {
            ---@since 1.0.0
            -- The template URL to use when downloading assets from GitHub.
            -- The placeholders are the following (in order):
            -- 1. The repository (e.g. "rust-lang/rust-analyzer")
            -- 2. The release version (e.g. "v0.3.0")
            -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
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

      'ray-x/lsp_signature.nvim',
      'b0o/schemastore.nvim',
      'folke/neodev.nvim',
    },
    opts = {
      capabilities = require('module.lsp').capabilities,
      on_attach = function(client, bufnr)
        require('lsp_signature').on_attach({
          bind = true, -- This is mandatory, otherwise border config won't get registered.
          handler_opts = {
            border = 'rounded',
          },
        }, bufnr)

        local lsp = require 'module.lsp'
        lsp.on_attach(client, bufnr)
      end,
      inlay_hints = {
        enabled = false,
      },
      servers = {
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
        lua_ls = {},
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
      },
    },
    config = function(_, opts)
      require('neodev').setup({
        library = {
          enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
          runtime = true, -- runtime path
          types = true,   -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
          ---@type boolean|string[]
          plugins = true, -- installed opt or start plugins in packpath
          -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
        },
        setup_jsonls = true,
        lspconfig = true,
        -- faster. needs lua-language-server >= 3.6.0
        pathStrict = true,
        debug = false,
      })
      local lsp = require 'module.lsp'
      lsp.setup_diagnostics()
      require('lsp-setup').setup(opts)
    end,
  },

  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    init = function()
      require('core.utils').load_plugin_with_func('fidget.nvim', vim, 'notify')
    end,
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
    config = function(_, opts)
      require('fidget').setup(opts)
      vim.notify = require('fidget.notification').notify
    end,
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
    enabled = vim.fn.has("nvim-0.10") == 1,
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
