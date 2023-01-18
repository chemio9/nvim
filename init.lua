_G.lazy_path = '/home/arch/pro/dotfiles'
require 'core.options'

require 'core.bootstrap'

require 'lazy'.setup('plugins', {
  root = lazy_path .. '/lazy', -- directory where plugins will be installed
  lockfile = lazy_path .. '/lazy-lock.json',
  defaults = { lazy = true },
  performance = {
    cache = {
      path = lazy_path .. '/lazy/cache',
    },
    reset_packpath = true,
    rtp = {
      ---@type string[]
      paths = {}, -- add any custom paths here that you want to indluce in the rtp
      ---@type string[] list any plugins you want to disable here
      disabled_plugins = {
        'tohtml',
        'gzip',
        'matchit',
        'zipPlugin',
        'netrwPlugin',
        'tarPlugin',
        'matchparen',
      },
    },
  },
  diff = {
    cmd = 'diffview.nvim',
  },
})

require 'core.keymap'.setup()
