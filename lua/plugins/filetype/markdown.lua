local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
autocmd('FileType', {
  pattern = 'markdown',
  group = augroup('FtLocalKeymaps', {}),
  callback = function(ev)
    vim.keymap.set('n', '<localleader>p', '<cmd>Glow<CR>',
      { noremap = true, desc = 'Preview markdown', buffer = ev.buf })
    vim.keymap.set('n', '<localleader>t', '<cmd>Markview toggleAll<CR>',
      { noremap = true, desc = 'Toggle Markview', buffer = ev.buf })
  end,
})

---@type LazySpec[]
return {
  {
    'ellisonleao/glow.nvim',
    ft = 'markdown',
    config = true,
  },

  {
    'OXY2DEV/markview.nvim',
    ft = 'markdown',
    cmd = 'Markview',
    opts = {
      buf_ignore = { 'nofile' },
      modes = { 'n', 'no' },
      -- options = {
      --   on_enable = {},
      --   on_disable = {},
      -- },
      -- block_quotes = {},
      -- checkboxes = {},
      -- code_blocks = {},
      -- headings = {},
      -- horizontal_rules = {},
      -- inline_codes = {},
      -- links = {},
      -- list_items = {},
      -- tables = {},
    },

    dependencies = {
      -- You may not need this if you don't lazy load
      -- Or if the parsers are in your $RUNTIMEPATH
      'nvim-treesitter/nvim-treesitter',

      'nvim-tree/nvim-web-devicons',
    },
  },
}
