local lazypath = vim.fn.stdpath 'config' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
  local oldcmdheight = vim.opt.cmdheight:get()
  vim.opt.cmdheight = 1
  vim.notify 'Please wait while plugins are installed...'
  vim.api.nvim_create_autocmd('User', {
    once = true,
    pattern = 'LazyInstall',
    callback = function()
      vim.cmd.bw()
      vim.opt.cmdheight = oldcmdheight
      vim.tbl_map(function(module) pcall(require, module) end,
                  { 'nvim-treesitter' })
    end,
  })
end
vim.opt.rtp:prepend(lazypath)

require 'lazy'.setup('plugins', {
  root = vim.fn.stdpath 'config' .. '/lazy', -- directory where plugins will be installed
  lockfile = vim.fn.stdpath 'config' .. '/lazy/lazy-lock.json',
  defaults = { lazy = true },
  performance = {
    cache = {
      disable_events = { 'UIEnter', 'BufReadPre' },
      ttl = 3600 * 24 * 2, -- keep unused modules for up to 2 days
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

