return {
  {
    'kylechui/nvim-surround',
    keys = { { 'ys' }, { 'ds' }, { 'cs' }, { 'v' } },
    config = true,
  },

  {
    'max397574/better-escape.nvim',
    event = 'InsertCharPre',
    config = true,
  },

  {
    'utilyre/sentiment.nvim',
    version = '*',
    event = 'User File', -- keep for lazy loading
    config = true,
    init = function()
      -- `matchparen.vim` needs to be disabled manually in case of lazy loading
      vim.g.loaded_matchparen = 1
    end,
  },

  {
    'jghauser/mkdir.nvim',
    init = function()
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('MkdirRun', {}),
        pattern = '*',
        callback = function()
          require('mkdir').run()
        end,
      })
    end,
  },

  {
    'rainbowhxch/accelerated-jk.nvim',
    event = 'CursorMoved',
    keys = {
      { 'j', '<Plug>(accelerated_jk_gj)' },
      { 'k', '<Plug>(accelerated_jk_gk)' },
    },
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },

  { 'famiu/bufdelete.nvim', cmd = { 'Bdelete', 'Bwipeout' } },

  {
    'cappyzawa/trim.nvim',
    event = 'BufWritePre',
    cmd = { 'Trim', 'TrimToggle' },
    opts = {
      ft_blocklist = {},
      patterns = {
        [[%s/\(\n\n\)\n\+/\1/]], -- replace multiple blank lines with a single line
      },
      trim_on_write = true,
      trim_trailing = true,
      trim_last_line = true,
      trim_first_line = true,
    },
  },

  {
    'sontungexpt/url-open',
    event = 'VeryLazy',
    cmd = 'URLOpenUnderCursor',
    keys = {
      { 'gx', '<cmd>URLOpenUnderCursor<CR>', desc = 'open url under cursor' },
    },
    config = function()
      local status_ok, url_open = pcall(require, 'url-open')
      if not status_ok then return end
      url_open.setup {}
    end,
  },

  {
    'monaqa/dial.nvim',
    keys = {
      {
        '<C-a>',
        function()
          require('dial.map').manipulate('increment', 'normal')
        end,
        mode = 'n',
      },
      {
        '<C-x>',
        function()
          require('dial.map').manipulate('decrement', 'normal')
        end,
        mode = 'n',
      },
      {
        'g<C-a>',
        function()
          require('dial.map').manipulate('increment', 'gnormal')
        end,
        mode = 'n',
      },
      {
        'g<C-x>',
        function()
          require('dial.map').manipulate('decrement', 'gnormal')
        end,
        mode = 'n',
      },
      {
        '<C-a>',
        function()
          require('dial.map').manipulate('increment', 'visual')
        end,
        mode = 'v',
      },
      {
        '<C-x>',
        function()
          require('dial.map').manipulate('decrement', 'visual')
        end,
        mode = 'v',
      },
      {
        'g<C-a>',
        function()
          require('dial.map').manipulate('increment', 'gvisual')
        end,
        mode = 'v',
      },
      {
        'g<C-x>',
        function()
          require('dial.map').manipulate('decrement', 'gvisual')
        end,
        mode = 'v',
      },
    },
    config = function()
      local augend = require 'dial.augend'
      require('dial.config').augends:register_group {
        default = {
          augend.constant.alias.bool,
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
        },
        typescript = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.new { elements = { 'let', 'const' } },
        },
        visual = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.alpha,
          augend.constant.alias.Alpha,
        },
      }
    end,
  },

  {
    'chrisgrieser/nvim-origami',
    event = 'BufReadPost', -- later or on keypress would prevent saving folds
    opts = {
      keepFoldsAcrossSessions = true,
      pauseFoldsOnSearch = true,
      setupFoldKeymaps = true,
    },
  },

  {
    'boltlessengineer/smart-tab.nvim',
    opts = {
      -- default options:
      -- list of tree-sitter node types to filter
      skips = { 'string_content' },
      -- map manually in lsp complete section
      ---@source ../module/cmp/init.lua:64
      mapping = false,
      -- filetypes to exclude
      exclude_filetypes = {},
    },
  },

  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  -- window managing
  {
    'mrjones2014/smart-splits.nvim',
    opts = {
      ignored_filetypes = {
        'nofile',
        'quickfix',
        'qf',
        'prompt',
      },
      ignored_buftypes = { 'nofile' },
    },

    keys = {
      {
        '<C-h>',
        function()
          require('smart-splits').move_cursor_left()
        end,
        desc = 'Move to left split',
      },
      {
        '<C-j>',
        function()
          require('smart-splits').move_cursor_down()
        end,
        desc = 'Move to below split',
      },
      {
        '<C-k>',
        function()
          require('smart-splits').move_cursor_up()
        end,
        desc = 'Move to above split',
      },
      {
        '<C-l>',
        function()
          require('smart-splits').move_cursor_right()
        end,
        desc = 'Move to right split',
      },
      {
        '<C-Up>',
        function()
          require('smart-splits').resize_up()
        end,
        desc = 'Resize split up',
      },
      {
        '<C-Down>',
        function()
          require('smart-splits').resize_down()
        end,
        desc = 'Resize split down',
      },
      {
        '<C-Left>',
        function()
          require('smart-splits').resize_left()
        end,
        desc = 'Resize split left',
      },
      {
        '<C-Right>',
        function()
          require('smart-splits').resize_right()
        end,
        desc = 'Resize split right',
      },
    },
  },

  {
    'echasnovski/mini.align',
    version = '*',
    keys = { { 'ga', mode = { 'n', 'v' } }, { 'gA', mode = { 'n', 'v' } } },
    config = true,
  },

  {
    'ellisonleao/glow.nvim',
    config = true,
    cmd = 'Glow',
  },
}
