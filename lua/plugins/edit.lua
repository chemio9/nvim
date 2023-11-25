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
          require 'mkdir'.run()
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
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require 'flash'.jump() end,       desc = 'Flash' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require 'flash'.treesitter() end, desc = 'Flash Treesitter' },
      { 'r', mode = 'o',               function() require 'flash'.remote() end,     desc = 'Remote Flash' },
      {
        'R',
        mode = { 'o', 'x' },
        function() require 'flash'.treesitter_search() end,
        desc =
        'Treesitter Search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function() require 'flash'.toggle() end,
        desc =
        'Toggle Flash Search',
      },
    },
  },

  { 'famiu/bufdelete.nvim', cmd = { 'Bdelete', 'Bwipeout' } },
}
