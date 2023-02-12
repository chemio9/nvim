require 'core.options'

require 'core.bootstrap'

require 'lazy'.setup('plugins', {
  root = vim.fn.stdpath 'config' .. '/lazy', -- directory where plugins will be installed
  lockfile = vim.fn.stdpath 'config' .. '/lazy/lazy-lock.json',
  defaults = { lazy = true },
  performance = {
    cache = {
      path = vim.fn.stdpath 'config' .. '/lazy/cache',
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      ---@type string[]
      paths = {}, -- add any custom paths here that you want to indluce in the rtp
      ---@type string[] list any plugins you want to disable here
      disabled_plugins = {
        'tohtml',
        -- 'gzip',
        -- 'zip',
        -- 'zipPlugin',
        -- 'tar',
        -- 'tarPlugin',
        'man',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'shada_plugin',
      },
    },
  },
  diff = {
    cmd = 'diffview.nvim',
  },
  dev = {
    -- directory where you store your local plugin projects
    path = '~/pro/',
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {},
    fallback = true, -- Fallback to git when local plugin doesn't exist
  },
})

require 'core.autocmds'
require('core.keymap').setup()
