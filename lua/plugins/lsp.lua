local plugin = {
  {
    'junnplus/lsp-setup.nvim',
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
      },
      'williamboman/mason-lspconfig.nvim',

      'ray-x/lsp_signature.nvim',
      'b0o/schemastore.nvim',
      'folke/neodev.nvim',
    },
    opts = {
      -- map the keys on my own
      default_mappings = false,
      -- TODO: seems like auto advertising proper capabilities to lsp
      --      considering remove the manual way
      capabilities = require 'module.lsp'.capabilities,
      on_attach = function(client, bufnr)
        -- Support custom the on_attach function for global
        -- Formatting on save as default
        -- require 'lsp-setup.utils'.format_on_save(client)

        require 'lsp_signature'.on_attach({
          bind = true, -- This is mandatory, otherwise border config won't get registered.
          handler_opts = {
            border = 'rounded',
          },
        }, bufnr)

        local lsp = require 'module.lsp'
        lsp.on_attach(client, bufnr)
        require 'core.utils'.event 'LspSetup'
      end,
      inlay_hints = {
        enabled = false,
      },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              hint = {
                enable = true,
                arrayIndex = 'Auto',
                await = true,
                paramName = 'All',
                paramType = true,
                semicolon = 'SameLine',
                setType = false,
              },
            },
          },
        },
        zls = {
          settings = {
            zls = {
              enable_inlay_hints = true,
              inlay_hints_show_builtin = true,
              inlay_hints_exclude_single_argument = true,
              inlay_hints_hide_redundant_param_names = false,
              inlay_hints_hide_redundant_param_names_last_token = false,
            },
          },
        },
        jsonls = function()
          return {
            settings = {
              json = {
                schemas = require 'schemastore'.json.schemas(),
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
                schemas = require 'schemastore'.yaml.schemas(),
              },
            },
          }
        end,
      },
    },
    config = function(_, opts)
      require 'neodev'.setup()
      local lsp = require 'module.lsp'
      lsp.setup_diagnostics()
      require 'lsp-setup'.setup(opts)
    end,
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
    event = 'User LspSetup',
    cmd = 'LspUI',
    config = true,
  },

  {
    'VidocqH/lsp-lens.nvim',
    event = 'User LspSetup',
    opts = {},
  },
}
return plugin
