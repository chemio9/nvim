return {
  {
    'numToStr/Comment.nvim',
    keys = { { 'gc', mode = { 'n', 'v' } }, { 'gb', mode = { 'n', 'v' } } },
    config = function()
      require 'module.cmp.comment'
    end,
  },
}
