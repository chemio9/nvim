---@type LazySpec[]
return {
  -- set to HEAD for now. still making too many changes for lazy itself
  { 'folke/lazy.nvim' },
  {
    'vhyrro/luarocks.nvim',
    priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
    config = true,
  },
}
