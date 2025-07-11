---@diagnostic disable: missing-fields
---@type LazySpec[]
local plugin = {
  {
    'neovim/nvim-lspconfig',
    event = 'BufRead',
    specs = {
      {
        'williamboman/mason.nvim',
        opts = {
          github = {
            -- download_url_template = 'https://ghproxy.net/github.com/%s/releases/download/%s/%s',
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
        'Zeioth/mason-extra-cmds',
        opts = {},
        cmd = 'MasonUpdateAll',
        init = function()
          vim.api.nvim_create_autocmd('User', {
            pattern = 'LazyInstall',
            callback = function()
              vim.cmd.MasonUpdateAll()
            end,
          })
        end,
      },
      {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        cmd = 'LazyDev',
        opts = {
          library = {
            'lazy.nvim',

            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            { path = 'wezterm-types',      mods = { 'wezterm' } },
          },
        },
        specs = {
          { 'Bilal2453/luvit-meta',        lazy = true }, -- `vim.uv` typings,
          { 'justinsgithub/wezterm-types', enabled = vim.fn.executable('wezterm') == 1 },
        },
      },

      {
        'b0o/schemastore.nvim',
      },
    },
    opts = {
      ---@type {[string]: lspconfig.Config|fun(): lspconfig.Config}
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
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = 'Replace',
              },
              doc = {
                privateName = { '^_' },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = 'Disable',
                semicolon = 'Disable',
                arrayIndex = 'Disable',
              },
            },
          },
        },
        -- zls = {
        --   settings = {
        --     zls = {
        --       enable_inlay_hints = true,
        --       inlay_hints_show_builtin = true,
        --       inlay_hints_exclude_single_argument = true,
        --       inlay_hints_hide_redundant_param_names = true,
        --       inlay_hints_hide_redundant_param_names_last_token = false,
        --     },
        --   },
        -- },
        gopls = {
          settings = {
            gopls = {
              buildFlags = {
                '-tags=wireinject',
              },
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        -- }}}
      },
    },
    config = function(_, opts)
      local lspconfig = require('lspconfig')

      require('vim.lsp.log').set_format_func(vim.inspect)
      lspconfig.util.default_config.capabilities = require('module.lsp').make_capabilities()

      local mason = require('mason')
      local mason_lspconfig = require('mason-lspconfig')
      if mason.has_setup then
        ---@diagnostic disable-next-line: missing-fields
        mason.setup {
          PATH = 'prepend',
        }
        ---@diagnostic disable-next-line: missing-fields
        mason_lspconfig.setup {}
      end

      for server_name, config in pairs(opts.servers) do
        if type(config) == 'function' then
          config = config()
        end

        vim.lsp.config(server_name, config)
        vim.lsp.enable(server_name)
      end

      local lsp = require 'module.lsp'
      lsp.setup_diagnostics()
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
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'qf',
        callback = function(args)
          local bufnr = args.buf
          vim.defer_fn(function()
            local winid = vim.fn.bufwinid(bufnr)
            if winid == -1 then
              return
            end
            vim.api.nvim_win_close(winid, true)
            require('trouble').open('quickfix')
          end, 0)
        end,
      })
    end,
    opts = {
      use_diagnostic_signs = true,
    },
  },

  {
    'ravibrock/spellwarn.nvim',
    event = 'User File',
    cmd = 'Spellwarn',
    config = true,
  },

  {
    'jinzhongjia/LspUI.nvim',
    branch = 'main',
    event = 'LspAttach',
    enabled = vim.fn.has('nvim-0.10') == 1 and false,
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
    enabled = false,
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
    dependencies = {
      'williamboman/mason.nvim',
    },
    -- require("conform")
    opts = function(_, opts)
      ---@type conform.setupOpts
      local prettier = { lsp_format = 'fallback', 'eslint_d' }
      local opt = {
        formatters_by_ft = {
          vue = prettier,
          ts = prettier,
          tsx = prettier,
          json = { lsp_format = 'fallback', 'prettier' },

          go = { 'gofumpt' },
          md = { 'injected' },
        },
        format_on_save = {
          ['lua'] = true,
        },
      }
      return vim.tbl_extend('force', opts, opt)
    end,
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
  },
  {
    'mfussenegger/nvim-lint',
    event = 'User File',
    dependencies = {
      'williamboman/mason.nvim',
    },
    config = function()
      require('lint').linters_by_ft = {
        -- TODO: biomejs/oxlint
        go = { 'golangcilint' },
        vue = { 'eslint_d' },
        ts = { 'eslint_d' },
        tsx = { 'eslint_d' },
      }

      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          -- try_lint without arguments runs the linters defined in `linters_by_ft`
          -- for the current filetype
          require('lint').try_lint()
        end,
      })
    end,
    keys = {
      { 'grl', function() require('lint').try_lint() end, desc = 'Lint' },
    },
  },
}
return plugin
