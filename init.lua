_G.lazy_path = '/home/arch/pro/dotfiles'
require 'core.options'

require 'core.bootstrap'

require 'lazy'.setup('plugins', {
  root = lazy_path .. '/lazy', -- directory where plugins will be installed
  lockfile = lazy_path .. '/lazy-lock.json',
  performance = {
    cache = {
      path = lazy_path .. '/lazy/cache',
    },
    reset_packpath = true,
    rtp = {
      -- TODO: nvim-cmp cant work properly when reset = true
      reset = false, -- reset the runtime path to $VIMRUNTIME and your config directory
      ---@type string[]
      paths = {}, -- add any custom paths here that you want to indluce in the rtp
      ---@type string[] list any plugins you want to disable here
      disabled_plugins = {
        'tohtml',
        'tutor',
      },
    },
  },
  diff = {
    cmd = 'diffview.nvim',
  },
})

require 'core.keymap'.setup()
