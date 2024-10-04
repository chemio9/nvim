---@type LazySpec[]
local plugin = {
  {
    'chenrry666/lsp-setup.nvim',
    event = 'BufRead',
    dependencies = {
      'neovim/nvim-lspconfig',
      {
        'williamboman/mason.nvim',
        opts = {
          github = {
            download_url_template = 'https://mirror.ghproxy.net/github.com/%s/releases/download/%s/%s',
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
    },
    opts = {
      capabilities = require('module.lsp').make_capabilities(),
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
    {
      'b0o/schemastore.nvim',
    },

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
    init = function()
      -- vim.api.nvim_create_autocmd('FileType', {
      --   pattern = 'qf',
      --   callback = function(args)
      --     local bufnr = args.buf
      --     vim.defer_fn(function()
      --       local winid = vim.fn.bufwinid(bufnr)
      --       if winid == -1 then
      --         return
      --       end
      --       vim.api.nvim_win_close(winid, true)
      --       require('trouble').open('quickfix')
      --     end, 0)
      --   end,
      -- })
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

  {
    'lewis6991/hover.nvim',
    enabled = false,
    -- FIXME: ufo
    -- dependencies = "kevinhwang91/nvim-ufo"
    config = function()
      require('hover').setup {
        init = function()
          -- Require providers
          require('hover.providers.lsp')
          -- require('hover.providers.gh')
          -- require('hover.providers.gh_user')
          -- require('hover.providers.jira')
          require('hover.providers.dap')
          -- require('hover.providers.fold_preview')
          require('hover.providers.diagnostic')
          require('hover.providers.man')
          require('hover.providers.dictionary')
        end,
        preview_opts = {
          border = 'rounded',
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = true,
        title = true,
        -- mouse_providers = {
        --   'LSP',
        -- },
        -- mouse_delay = 1000,
      }

      -- Setup keymaps
      vim.keymap.set('n', 'K', require('hover').hover, { desc = 'hover.nvim' })
      vim.keymap.set('n', 'gK', require('hover').hover_select, { desc = 'hover.nvim (select)' })
      -- vim.keymap.set('n', '<C-p>', function() require('hover').hover_switch('previous') end, { desc = 'hover.nvim (previous source)' })
      -- vim.keymap.set('n', '<C-n>', function() require('hover').hover_switch('next') end, { desc = 'hover.nvim (next source)' })
      -- -- Mouse support
      -- vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = 'hover.nvim (mouse)' })
      -- vim.o.mousemoveevent = true
    end,
  },
}
return plugin
