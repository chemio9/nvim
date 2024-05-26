return {
  {
    'kylechui/nvim-surround',
    keys = { { 'ys' }, { 'ds' }, { 'cs' }, { 'v' } },
    config = true,
  },

  {
    'gbprod/substitute.nvim',
    config = function()
      require('substitute').setup()
    end,
    keys = {
      { 's',   function() require('substitute').operator() end,          mode = 'n', { noremap = true } },
      { 'ss',  function() require('substitute').line() end,              mode = 'n', { noremap = true } },
      { 'S',   function() require('substitute').eol() end,               mode = 'n', { noremap = true } },
      { 's',   function() require('substitute').visual() end,            mode = 'x', { noremap = true } },

      { 'sx',  function() require('substitute.exchange').operator() end, mode = 'n', { noremap = true } },
      { 'sxx', function() require('substitute.exchange').line() end,     mode = 'n', { noremap = true } },
      { 'X',   function() require('substitute.exchange').visual() end,   mode = 'x', { noremap = true } },
      { 'sxc', function() require('substitute.exchange').cancel() end,   mode = 'n', { noremap = true } },
    },
  },

  {
    'max397574/better-escape.nvim',
    event = 'InsertCharPre',
    config = true,
  },

  {
    'utilyre/sentiment.nvim',
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
      { 'm',     mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,              desc = 'Flash' },
      { 'M',     mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end,        desc = 'Flash Treesitter' },
      { 'r',     mode = 'o',               function() require('flash').remote() end,            desc = 'Remote Flash' },
      { 'R',     mode = { 'o', 'x' },      function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      { '<c-s>', mode = { 'c' },           function() require('flash').toggle() end,            desc = 'Toggle Flash Search' },
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
    'chrishrb/gx.nvim',
    event = 'VeryLazy',
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    keys = {
      { 'gx', function() vim.cmd.Browse() end, mode = { 'n', 'x' } },
    },
    cmd = {
      'Browse',
    },
    opts = {
      handler_options = {
        search_engine = 'bing',
        select_for_search = false,
      },
    },
  },

  {
    'monaqa/dial.nvim',
    keys = {
      {
        '<C-a>',
        function() require('dial.map').manipulate('increment', 'normal') end,
      },
      {
        '<C-x>',
        function() require('dial.map').manipulate('decrement', 'normal') end,
      },
      {
        'g<C-a>',
        function() require('dial.map').manipulate('increment', 'gnormal') end,
      },
      {
        'g<C-x>',
        function() require('dial.map').manipulate('decrement', 'gnormal') end,
      },
      {
        '<C-a>',
        function() require('dial.map').manipulate('increment', 'visual') end,
        mode = 'v',
      },
      {
        '<C-x>',
        function() require('dial.map').manipulate('decrement', 'visual') end,
        mode = 'v',
      },
      {
        'g<C-a>',
        function() require('dial.map').manipulate('increment', 'gvisual') end,
        mode = 'v',
      },
      {
        'g<C-x>',
        function() require('dial.map').manipulate('decrement', 'gvisual') end,
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
      keepFoldsAcrossSessions = false,
      pauseFoldsOnSearch = true,
      setupFoldKeymaps = true,
    },
  },

  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = {
      'TodoLocList',
      'TodoTrouble',
      'TodoTelescope',
      'TodoQuickFix',
    },
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
        function() require('smart-splits').move_cursor_left() end,
        desc = 'Move to left split',
      },
      {
        '<C-j>',
        function() require('smart-splits').move_cursor_down() end,
        desc = 'Move to below split',
      },
      {
        '<C-k>',
        function() require('smart-splits').move_cursor_up() end,
        desc = 'Move to above split',
      },
      {
        '<C-l>',
        function() require('smart-splits').move_cursor_right() end,
        desc = 'Move to right split',
      },
      {
        '<C-Up>',
        function() require('smart-splits').resize_up() end,
        desc = 'Resize split up',
      },
      {
        '<C-Down>',
        function() require('smart-splits').resize_down() end,
        desc = 'Resize split down',
      },
      {
        '<C-Left>',
        function() require('smart-splits').resize_left() end,
        desc = 'Resize split left',
      },
      {
        '<C-Right>',
        function() require('smart-splits').resize_right() end,
        desc = 'Resize split right',
      },
    },
  },

  {
    'echasnovski/mini.align',
    keys = { { 'ga', mode = { 'n', 'v' } }, { 'gA', mode = { 'n', 'v' } } },
    config = true,
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      require('ufo').setup()
    end,
    keys = {
      { 'zR', function() require('ufo').openAllFolds() end },
      { 'zM', function() require('ufo').closeAllFolds() end },
      { 'zr', function() require('ufo').openFoldsExceptKinds() end },
      { 'zm', function() require('ufo').closeFoldsWith() end }, -- closeAllFolds == closeFoldsWith(0)
    },
  },

  {
    'keaising/im-select.nvim',
    event = 'BufEnter',
    config = function()
      require('im_select').setup({})
    end,
  },

  {
    'tiagovla/scope.nvim',
    event = 'WinEnter',
    cmd = {
      'ScopeMoveBuf',
    },
    config = true,
    -- TODO: config when add a session manager
  },
}
