---@type LazySpec[]
return {
  {
    'davidmh/mdx.nvim',
    event = 'BufEnter *.mdx',
    lazy = false,
    specs = { 'nvim-treesitter/nvim-treesitter' },
  },
}
