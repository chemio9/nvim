return {
  {
    'numToStr/Comment.nvim',
    keys = { 'gc', 'gb' },
    config = function()
      require 'module.cmp.comment'
    end,
  },
}
