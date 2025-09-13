---@type LazySpec[]
return {
  {
    'davidmh/mdx.nvim',
    event = 'BufEnter *.mdx',
    lazy = false,
    config = true,
    specs = { 'nvim-treesitter/nvim-treesitter' },
  },
}
