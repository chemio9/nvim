return {
  {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function()
      require 'module.statusline'
    end,
    lazy = false,
    enabled = false,
  },
}
