return {
  {
    'rcarriga/nvim-notify',
    event = 'VeryLazy',
    config = function()
      require 'module.notify'
    end,
  },

  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
    config = function()
      require 'module.dressing'
    end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    cmd = {
      'ColorizerToggle',
      'ColorizerAttachToBuffer',
      'ColorizerDetachFromBuffer',
      'ColorizerReloadAllBuffers',
    },
    event = 'VeryLazy',
    config = function()
      require 'colorizer'.setup { user_default_options = { names = false } }
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VeryLazy',
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
    'quocnho/nvim-pqf',
    event = 'UIEnter',
    config = function()
      local icons = require 'core.icons'
      require 'pqf'.setup {
        signs = {
          error = icons.DiagnosticError,
          warning = icons.DiagnosticWarn,
          info = icons.DiagnosticInfo,
          hint = icons.DiagnosticHint,
        },
      }
    end,
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require 'which-key'.setup {
        operators = { gc = 'Comments' },
        key_labels = {
          -- override the label used to display
          ['<space>'] = 'SPC',
        },
      }
    end,
  },

  {
    'romainl/vim-cool',
    enabled = false,
  },

  {
    'gelguy/wilder.nvim',
    event = 'UIEnter',
    config = function()
      local wilder = require 'wilder'
      wilder.setup { modes = { ':', '/', '?' } }
      -- Disable Python remote plugin
      wilder.set_option('use_python_remote_plugin', 0)

      wilder.set_option('pipeline', {
        wilder.branch(
        wilder.cmdline_pipeline {
          fuzzy = 1,
          fuzzy_filter = wilder.lua_fzy_filter(),
        },
            wilder.vim_search_pipeline()
        ),
      })

      wilder.set_option('renderer', wilder.renderer_mux {
        [':'] = wilder.popupmenu_renderer {
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
        },
      })
    end,
    dependencies = 'romgrk/fzy-lua-native',
  },
}
