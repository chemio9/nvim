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
        backend = { 'fzf_lua', 'builtin' },
        builtin = { win_options = { winhighlight = 'normal:normal,normalnc:normal' } },
      },
    },
  },

  {
    'uga-rosa/ccc.nvim',
    event = 'User File',
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
    'HiPhish/rainbow-delimiters.nvim',
    enabled = false,
    event = 'User File',
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
          { mode = 'n', keys = '<Localleader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          { mode = 'n', keys = '[' },
          { mode = 'n', keys = ']' },

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
          { mode = 'n', keys = '<leader>b',  desc = '+Buffer' },
          { mode = 'n', keys = '<leader>c',  desc = '+LSP' },
          { mode = 'n', keys = '<leader>d',  desc = '+Debugger' },
          { mode = 'n', keys = '<leader>e',  desc = '+Diagnostics' },
          { mode = 'n', keys = '<leader>ew', desc = '+Workspaces' },
          { mode = 'n', keys = '<leader>g',  desc = '+Git' },
          { mode = 'n', keys = '<leader>t',  desc = '+Terminal' },
          { mode = 'n', keys = '<leader>s',  desc = '+Session' },
          { mode = 'n', keys = '<leader>r',  desc = '+Runner' },
          { mode = 'n', keys = '<leader>f',  desc = '+File Manager' },
        },

        window = {
          config = { anchor = 'SE' --[[ bottom right ]], row = 'auto', col = 'auto' },
        },
      }
    end,
  },

  {
    'nvimdev/hlsearch.nvim',
    event = 'VeryLazy',
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
    init = function()
      local autocmd = require('core.utils').autocmd
      local augroup = require('core.utils').augroup

      local alpha_group = augroup('alpha_settings')
      autocmd('User', {
        desc = 'Disable status and tablines for alpha',
        group = alpha_group,
        pattern = 'AlphaReady',
        callback = function()
          local prev_showtabline = vim.opt.showtabline
          local prev_status = vim.opt.laststatus
          vim.opt.laststatus = 0
          vim.opt.showtabline = 0
          vim.opt_local.winbar = nil
          autocmd('BufUnload', {
            pattern = '<buffer>',
            once = true,
            callback = function()
              vim.opt.laststatus = prev_status
              vim.opt.showtabline = prev_showtabline
            end,
          })
        end,
      })

      autocmd('VimEnter', {
        desc = 'Start Alpha when vim is opened with no arguments',
        group = alpha_group,
        once = true,
        callback = function()
          local should_skip = false
          ---@diagnostic disable-next-line: param-type-mismatch
          if vim.fn.argc() > 0 or vim.fn.line2byte '$' ~= -1 or not vim.o.modifiable then
            should_skip = true
          else
            for _, arg in pairs(vim.v.argv) do
              if arg == '-b' or arg == '-c' or vim.startswith(arg, '+') or arg == '-S' then
                should_skip = true
                break
              end
            end
          end
          if not should_skip then
            local alpha_avail, alpha = pcall(require, 'alpha')
            if alpha_avail then
              alpha.start(false)
            end
          end
        end,
      })
    end,
    config = function()
      require 'module.alpha'
    end,
  },

  {
    'mikavilpas/yazi.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    event = 'BufAdd',
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
      open_for_directories = true,
    },
  },

  { 'kevinhwang91/nvim-bqf', ft = 'qf' },

}
