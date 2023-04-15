return {
  {
    'rcarriga/nvim-notify',
    init = function()
      require 'core.utils'.load_plugin_with_func('nvim-notify', vim, 'notify')
    end,
    config = function()
      require 'module.notify'
    end,
  },

  {
    'stevearc/dressing.nvim',
    init = function()
      require 'core.utils'.load_plugin_with_func('dressing.nvim', vim.ui, { 'input', 'select' })
    end,
    config = function()
      require 'module.dressing'
    end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    event = 'User File',
    config = function()
      require 'colorizer'.setup { user_default_options = { names = false } }
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'User File',
    config = function()
      require 'indent_blankline'.setup {
        buftype_exclude = {
          'nofile',
          'terminal',
        },
        filetype_exclude = {
          'help',
          'startify',
          'aerial',
          'alpha',
          'dashboard',
          'lazy',
          'neogitstatus',
          'NvimTree',
          'neo-tree',
          'Trouble',
        },
        context_patterns = {
          'class',
          'return',
          'function',
          'method',
          '^if',
          '^while',
          'jsx_element',
          '^for',
          '^object',
          '^table',
          'block',
          'arguments',
          'if_statement',
          'else_clause',
          'jsx_element',
          'jsx_self_closing_element',
          'try_statement',
          'catch_clause',
          'import_statement',
          'operation_type',
        },
        show_trailing_blankline_indent = false,
        use_treesitter = true,
        char = '▏',
        context_char = '▏',
        show_current_context = true,
      }
    end,
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require 'which-key'.setup {
        operators = { gc = 'Comments', gb = 'Comments' },
        key_labels = {
          -- override the label used to display
          ['<space>'] = 'SPC',
        },
      }
    end,
  },

  {
    'romainl/vim-cool',
    keys = '/',
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

      wilder.set_option('renderer', wilder.renderer_mux {
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
      })
    end,
    dependencies = 'romgrk/fzy-lua-native',
  },
}
