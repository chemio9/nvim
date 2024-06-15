---@type LazySpec[]
return {
  {
    'stevearc/dressing.nvim',
    init = function()
      require('core.utils').load_plugin_with_func('dressing.nvim', vim.ui, { 'input', 'select' })
    end,
    opts = {
      input = {
        default_prompt = '➤ ',
        win_options = { winhighlight = 'normal:normal,normalnc:normal' },
      },
      select = {
        backend = { 'telescope', 'builtin' },
        builtin = { win_options = { winhighlight = 'normal:normal,normalnc:normal' } },
      },
    },
  },

  {
    'uga-rosa/ccc.nvim',
    event = 'BufRead',
    cmd = {
      'CccPick',
      'CccConvert',
      'CccHighlighterEnable',
      'CccHighlighterDisable',
      'CccHighlighterToggle',
    },
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = true,
      },
    },
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'User File',
    main = 'ibl',
    opts = {},
  },

  {
    'HiPhish/rainbow-delimiters.nvim',
    event = 'BufRead',
    config = function()
      -- This module contains a number of default definitions
      local rainbow_delimiters = require 'rainbow-delimiters'

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end,
  },

  -- {
  --   'folke/which-key.nvim',
  --   event = 'VeryLazy',
  --   config = function()
  --     require('which-key').setup {
  --       operators = { gc = 'Comments', gb = 'Comments' },
  --       key_labels = {
  --         -- override the label used to display
  --         ['<space>'] = 'SPC',
  --         ['<leader>'] = 'LDR',
  --       },
  --     }
  --   end,
  -- },
  {
    'echasnovski/mini.clue',
    version = false,
    event = 'VeryLazy',
    opts = function()
      local miniclue = require('mini.clue')
      return {
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },
        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),

          -- custom keymaps
          { mode = 'n', keys = '<leader>b', desc = '+Buffer' },
          { mode = 'n', keys = '<leader>c', desc = '+LSP' },
          { mode = 'n', keys = '<leader>d', desc = '+Debugger' },
          { mode = 'n', keys = '<leader>e', desc = '+Diagnostics' },
          { mode = 'n', keys = '<leader>ew', desc = '+Workspaces' },
          { mode = 'n', keys = '<leader>g', desc = '+Git' },
          { mode = 'n', keys = '<leader>t', desc = '+Terminal' },
          { mode = 'n', keys = '<leader>s', desc = '+Session' },
          { mode = 'n', keys = '<leader>r', desc = '+Runner' },
          { mode = 'n', keys = '<leader>f', desc = '+File Manager' },
        },

        window = {
          config = { anchor = 'SE' --[[ bottom right ]], row = 'auto', col = 'auto' },
        },
      }
    end,
  },

  {
    'nvimdev/hlsearch.nvim',
    event = 'BufRead',
    config = true,
  },

  {
    'gelguy/wilder.nvim',
    -- TODO: load it at a proper time TOO SLOW! Damn
    enabled = false,
    config = function()
      local wilder = require 'wilder'
      wilder.setup { modes = { ':', '/', '?' } }
      -- Disable Python remote plugin
      wilder.set_option('use_python_remote_plugin', 0)

      wilder.set_option('pipeline', {
        wilder.branch(
          wilder.cmdline_pipeline {
            use_python = 0,
            fuzzy = 1,
            fuzzy_filter = wilder.lua_fzy_filter(),
          },
          wilder.vim_search_pipeline()
        ),
      })

      wilder.set_option(
        'renderer',
        wilder.renderer_mux {
          [':'] = wilder.popupmenu_renderer {
            empty_message = wilder.popupmenu_empty_message_with_spinner(),
            highlighter = wilder.lua_fzy_highlighter(),
            highlights = {
              accent = wilder.make_hl('WilderAccent', 'CmpItemAbbrMatch'),
            },
            left = {
              ' ',
              wilder.popupmenu_devicons(),
            },
            right = {
              ' ',
              wilder.popupmenu_scrollbar(),
            },
          },
          ['/'] = wilder.wildmenu_renderer {
            highlighter = wilder.lua_fzy_highlighter(),
            apply_incsearch_fix = true,
            separator = ' | ',
            left = { ' ', wilder.wildmenu_spinner(), ' ' },
            right = { ' ', wilder.wildmenu_index() },
          },
        }
      )
    end,
    dependencies = 'romgrk/fzy-lua-native',
  },

  {
    'folke/zen-mode.nvim',
    cmd = {
      'ZenMode',
    },
    opts = {
      window = {
        backdrop = 1,
      },
    },
  },

  {
    'goolord/alpha-nvim',
    cmd = 'Alpha',
    config = function()
      require 'module.alpha'
    end,
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<c-f>',
        function()
          if not require('noice.lsp').scroll(4) then
            return '<c-f>'
          end
        end,
        mode = { 'n', 'i', 's' },
        silent = true,
        expr = true,
      },

      {
        '<c-b>',
        function()
          if not require('noice.lsp').scroll(-4) then
            return '<c-b>'
          end
        end,
        mode = { 'n', 'i', 's' },
        silent = true,
        expr = true,
      },
    },
    opts = {
      cmdline = {
        view = 'cmdline',
      },
      -- add any options here
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',

      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      {
        'rcarriga/nvim-notify',
        enabled = false,
        init = function()
          -- require('core.utils').load_plugin_with_func('nvim-notify', vim, 'notify')
        end,
        config = function()
          require 'module.notify'
        end,
      },
    },
  },

  {
    'mikavilpas/yazi.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- event = 'VeryLazy',
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        '<leader>ff',
        function()
          require('yazi').yazi()
        end,
        desc = 'Open the file manager',
      },
      {
        -- Open in the current working directory
        '<leader>fw',
        function()
          require('yazi').yazi(nil, vim.fn.getcwd())
        end,
        desc = "Open the file manager in nvim's working directory",
      },
    },
    ---@type YaziConfig
    opts = {
      open_for_directories = false,
    },
  },

}
