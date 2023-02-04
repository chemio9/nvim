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
    config = function()
      require 'colorizer'.setup { user_default_options = { names = false } }
    end,
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'UIEnter',
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
    -- doesn't need to lazy-load because it's tiny (single file)
    lazy = false,
    config = true,
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require 'which-key'.setup {
        operators = { gc = 'Comments' },
        key_labels = {
          -- override the label used to display
          ["<space>"] = "SPC",
        },
      }
    end,
  },
}
