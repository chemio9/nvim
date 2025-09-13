---@type LazySpec[]
return {
  -- default_prompt = '➤ ',
  -- win_options = { winhighlight = 'normal:normal,normalnc:normal' },

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
    'mikavilpas/yazi.nvim',
    lazy = false,
    event = { 'BufAdd', 'VimEnter' },
    specs = {
      'nvim-lua/plenary.nvim',
    },
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

  {
    'Aasim-A/scrollEOF.nvim',
    event = { 'CursorMoved', 'WinScrolled' },
    opts = {},
  }

}
