return {
  {
    'rmehri01/onenord.nvim',
    config = function()
      require 'module.onenord'
    end,
    priority = 100, -- load theme first
    lazy = false,
  },
}
