---@type LazySpec[]
return {
  {
    'rcarriga/nvim-notify',
    init = function()
      -- require('core.utils').load_plugin_with_func('nvim-notify', vim, 'notify')
    end,
    config = function()
      require 'module.notify'
    end,
  },

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
    'NvChad/nvim-colorizer.lua',
    event = 'BufRead',
    opts = { user_default_options = { names = false } },
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

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup {
        operators = { gc = 'Comments', gb = 'Comments' },
        key_labels = {
          -- override the label used to display
          ['<space>'] = 'SPC',
          ['<leader>'] = 'LDR',
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
    'nanozuki/tabby.nvim',
    event = 'VimEnter',
    dependencies = 'nvim-tree/nvim-web-devicons',
    keys = {
      { '<leader>ta',  ':$tabnew<CR>',  noremap = true, desc = 'New Tab' },
      { '<leader>tc',  ':tabclose<CR>', noremap = true, desc = 'Close Tab' },
      { '<leader>to',  ':tabonly<CR>',  noremap = true, desc = 'Only Tab' },
      { '<leader>tn',  ':tabn<CR>',     noremap = true, desc = 'Next Tab' },
      { '<leader>tp',  ':tabp<CR>',     noremap = true, desc = 'Prev Tab' },
      { '<leader>tmp', ':-tabmove<CR>', noremap = true, desc = 'Move Tab Prev' },
      { '<leader>tmn', ':+tabmove<CR>', noremap = true, desc = 'Move tab next' },
    },
    config = function()
      vim.o.showtabline = 2
      vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'

      local theme = {
        fill = 'TabLineFill',
        -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
        head = 'TabLine',
        current_tab = 'TabLineSel',
        tab = 'TabLine',
        win = 'TabLine',
        tail = 'TabLine',
      }
      require('tabby.tabline').set(function(line)
        return {
          {
            { '  ', hl = theme.head },
            line.sep('', theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep('', hl, theme.fill),
              tab.is_current() and '' or '󰆣',
              tab.number(),
              tab.name(),
              tab.close_btn('󰖭'),
              line.sep('', hl, theme.fill),
              hl = hl,
              margin = ' ',
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            return {
              line.sep('', theme.win, theme.fill),
              win.is_current() and '' or '',
              win.buf_name(),
              line.sep('', theme.win, theme.fill),
              hl = theme.win,
              margin = ' ',
            }
          end),
          {
            line.sep('', theme.tail, theme.fill),
            { '  ', hl = theme.tail },
          },
          hl = theme.fill,
        }
      end)
    end,
  },
}
