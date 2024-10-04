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
        dependencies = {
          { 'Bilal2453/luvit-meta',        lazy = true }, -- `vim.uv` typings,
          { 'justinsgithub/wezterm-types', enabled = vim.fn.executable('wezterm') == 1 },
        },
      },

      {
        'b0o/schemastore.nvim',
      },
    },
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
        ts_ls = {},
        emmet_ls = {},
        volar = {},
        -- }}}
      },
    },
    config = function(_, opts)
      local lspconfig = require('lspconfig')
      lspconfig.util.default_config.capabilities = require('module.lsp').make_capabilities()

      local mason = require('mason')
      local mason_lspconfig = require('mason-lspconfig')
      if mason.has_setup then
        mason.setup {}
        mason_lspconfig.setup {}
      end

      for server_name, config in pairs(opts.servers) do
        if type(config) == 'function' then
          config = config()
        end

        -- local is_installed = vim.fn.executable(
        --         require("lspconfig.server_configurations." .. server_name).default_config.cmd[1]) == 1
        -- TODO this is time costly to check if the file executable
        -- for instance my 10 servers costs ~60ms
        --
        -- if not is_installed then
        --     table.insert(ensure_install, server_name)
        -- end

        require('lspconfig')[server_name].setup(config)
      end

      -- mason_lspconfig.setup {
      --     ensure_installed = ensure_install
      -- }
      mason_lspconfig.setup_handlers({
        function(server_name)
          local config = opts.servers[server_name] or nil
          -- only setup the servers that we don't manually setup
          if config == nil then
            require('lspconfig')[server_name].setup(config)
          end
        end,
      })
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
    opts = {
      formatters_by_ft = {},
    },
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
  },
}
return plugin
