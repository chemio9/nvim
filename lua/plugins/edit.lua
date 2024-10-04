---@type LazySpec[]
return {
  {
    'kylechui/nvim-surround',
    keys = { { 'ys' }, { 'ds' }, { 'cs' }, { 'v' } },
    config = true,
  },

  {
    'gbprod/substitute.nvim',
    opts = {
      on_substitute = function() require('yanky.integration').substitute() end,
    },
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
    'gbprod/yanky.nvim',
    dependencies = {
      { 'kkharji/sqlite.lua' },
    },
    opts = {
      ring = { storage = 'sqlite' },
    },
    keys = {
      {
        '<leader>p',
        '<cmd>YankyRingHistory<CR>',
        desc = 'Open Yank History',
      },
      { 'y',     '<Plug>(YankyYank)',                      desc = 'Yank text',                                 mode = { 'n', 'x' } },
      { 'p',     '<Plug>(YankyPutAfter)',                  desc = 'Put yanked text after cursor',              mode = { 'n', 'x' } },
      { 'P',     '<Plug>(YankyPutBefore)',                 desc = 'Put yanked text before cursor',             mode = { 'n', 'x' } },
      { 'gp',    '<Plug>(YankyGPutAfter)',                 desc = 'Put yanked text after selection',           mode = { 'n', 'x' } },
      { 'gP',    '<Plug>(YankyGPutBefore)',                desc = 'Put yanked text before selection',          mode = { 'n', 'x' } },
      { '<c-p>', '<Plug>(YankyPreviousEntry)',             desc = 'Select previous entry through yank history' },
      { '<c-n>', '<Plug>(YankyNextEntry)',                 desc = 'Select next entry through yank history' },
      { ']p',    '<Plug>(YankyPutIndentAfterLinewise)',    desc = 'Put indented after cursor (linewise)' },
      { '[p',    '<Plug>(YankyPutIndentBeforeLinewise)',   desc = 'Put indented before cursor (linewise)' },
      { ']P',    '<Plug>(YankyPutIndentAfterLinewise)',    desc = 'Put indented after cursor (linewise)' },
      { '[P',    '<Plug>(YankyPutIndentBeforeLinewise)',   desc = 'Put indented before cursor (linewise)' },
      { '>p',    '<Plug>(YankyPutIndentAfterShiftRight)',  desc = 'Put and indent right' },
      { '<p',    '<Plug>(YankyPutIndentAfterShiftLeft)',   desc = 'Put and indent left' },
      { '>P',    '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'Put before and indent right' },
      { '<P',    '<Plug>(YankyPutIndentBeforeShiftLeft)',  desc = 'Put before and indent left' },
      { '=p',    '<Plug>(YankyPutAfterFilter)',            desc = 'Put after applying a filter' },
      { '=P',    '<Plug>(YankyPutBeforeFilter)',           desc = 'Put before applying a filter' },
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
    'rainbowhxch/accelerated-jk.nvim',
    event = { 'CursorMoved', 'CursorMovedI' },
    opt = {
      enable_deceleration = true,
    },
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

  {
    'famiu/bufdelete.nvim',
    cmd = { 'Bdelete', 'Bwipeout' },
    keys = {
      { '<leader>bw', '<cmd>Bwipeout<CR>', desc = 'Bwipeout' },
      { '<leader>bd', '<cmd>Bdelete<CR>',  desc = 'Bdelete' },
    },
  },

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
    init = function()
      vim.g.netrw_nogx = 1 -- disable netrw gx
    end,
    dependencies = { 'nvim-lua/plenary.nvim' },
    submodules = false,
    keys = {
      { 'gx', function() vim.cmd.Browse() end, mode = { 'n', 'x' } },
    },
    cmd = { 'Browse' },
    opts = {
      handler_options = {
        search_engine = 'bing',
        select_for_search = true,
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
    event = 'User File',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = {
      'TodoLocList',
      'TodoTrouble',
      'TodoTelescope',
      'TodoQuickFix',
    },
    opts = {},
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
      { '<C-h>',     function() require('smart-splits').move_cursor_left() end,  desc = 'Move to left split' },
      { '<C-j>',     function() require('smart-splits').move_cursor_down() end,  desc = 'Move to below split' },
      { '<C-k>',     function() require('smart-splits').move_cursor_up() end,    desc = 'Move to above split' },
      { '<C-l>',     function() require('smart-splits').move_cursor_right() end, desc = 'Move to right split' },
      { '<C-Up>',    function() require('smart-splits').resize_up() end,         desc = 'Resize split up' },
      { '<C-Down>',  function() require('smart-splits').resize_down() end,       desc = 'Resize split down' },
      { '<C-Left>',  function() require('smart-splits').resize_left() end,       desc = 'Resize split left' },
      { '<C-Right>', function() require('smart-splits').resize_right() end,      desc = 'Resize split right' },
    },
  },

  {
    'echasnovski/mini.align',
    keys = {
      { 'ga', mode = { 'n', 'v' } },
      { 'gA', mode = { 'n', 'v' } },
    },
    config = true,
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'BufReadPost',
    config = function()
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { 'treesitter', 'indent' }
        end,
      })
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
    enabled = vim.fn.executable('fcitx5-remote') == 1,
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
  },

  {
    'NMAC427/guess-indent.nvim',
    cmd = 'GuessIndent',
    config = true,
    event = { 'BufNew', 'BufReadPre' },
  },

  {
    'otavioschwanck/arrow.nvim',
    opts = {
      show_icons = true,
      leader_key = ';',        -- Recommended to be a single key
      buffer_leader_key = 'm', -- Per Buffer Mappings
      window = {
        border = 'rounded',
      },
    },
    keys = {
      { ';' },
      { 'm' },
    },
  },

  {
    'chrisgrieser/nvim-spider',
    main = 'spider',
    rocks = { 'luautf8' },
    keys = {
      {
        mode = { 'n', 'o', 'x' },
        'w',
        "<cmd>lua require('spider').motion('w')<CR>",
        desc = 'Spider-w',
      },
      {
        mode = { 'n', 'o', 'x' },
        'e',
        "<cmd>lua require('spider').motion('e')<CR>",
        desc = 'Spider-e',
      },
      {
        mode = { 'n', 'o', 'x' },
        'b',
        "<cmd>lua require('spider').motion('b')<CR>",
        desc = 'Spider-b',
      },
    },
  },

}
