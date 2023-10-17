local luasnip = require 'luasnip'
require 'luasnip'.config.setup {
  history = true,
  delete_check_events = 'TextChanged',
  region_check_events = 'CursorMoved',
}

vim.tbl_map(
  function(type) require('luasnip.loaders.from_' .. type).lazy_load() end,
  { 'vscode', 'snipmate', 'lua' }
)
