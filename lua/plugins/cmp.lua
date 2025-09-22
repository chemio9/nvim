---@type LazySpec[]
local plugin = {
  {
    'hrsh7th/nvim-cmp',
    enabled = false,
    event = {
      'InsertEnter',
      'CmdlineEnter',
    },
    dependencies = {
      -- Completion sources
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',

      { url = 'https://codeberg.org/FelipeLema/cmp-async-path' },

      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-omni',
      'f3fora/cmp-spell',
      'saadparwaiz1/cmp_luasnip',
      'doxnit/cmp-luasnip-choice',

      'lukas-reineke/cmp-under-comparator',

    },
    config = function()
      require 'module.cmp'
    end,
  },

  {
    'nvim-tree/nvim-web-devicons',
    opts = {
      default = true,
    },
  },

  {
    'saghen/blink.cmp',
    -- pre-built binaries
    event = {
      'InsertEnter',
      'CmdlineEnter',
    },
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    specs = {
      'onsails/lspkind.nvim',
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'enter' },

      appearance = {
        nerd_font_variant = 'normal',
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = {
        documentation = { auto_show = false },

        ghost_text = {
          enabled = true,
        },

        accept = { auto_brackets = { enabled = true } },

        menu = {
          auto_show = true,

          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                    local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require('lspkind').symbolic(ctx.kind, {
                      mode = 'symbol',
                    })
                  end

                  return icon .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                    local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
            },
          },
        },
      },

      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },

        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },

      snippets = { preset = 'luasnip' },

      fuzzy = { implementation = 'prefer_rust_with_warning' },

      signature = {
        enabled = true,
      },

      cmdline = {
        enabled = true,
        keymap = {
          -- recommended, as the default keymap will only show and select the next item
          ['<Tab>'] = { 'show', 'accept' },
          ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
        completion = { menu = { auto_show = true } },
      },
    },
    opts_extend = { 'sources.default' },
  },

  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gc',  mode = { 'v', 'o' } },
      { 'gb',  mode = { 'n', 'v' } },
      { 'gcc', mode = { 'n' } },
    },
    config = function()
      require 'module.cmp.comment'
    end,
  },

  {
    'L3MON4D3/LuaSnip',
    build = vim.fn.has 'win32' == 0
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
        or nil,
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    main = 'luasnip',
    opts = {
      history = true,
      delete_check_events = 'TextChanged',
      region_check_events = 'CursorMoved',
    },
    config = function(_, opts)
      local luasnip = require 'luasnip'
      luasnip.setup(opts)

      vim.tbl_map(function(type)
        require('luasnip.loaders.from_' .. type).lazy_load()
      end, { 'vscode', 'snipmate', 'lua' })
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require 'module.cmp.pairs'
    end,
  },
}
return plugin
