local LAZYPATH = vim.fn.getenv 'HOME' .. '/.cache/lazy_nvim'
local LAZYREPO = 'https://ghproxy.com/github.com/folke/lazy.nvim.git'
if not vim.uv.fs_stat(LAZYPATH) then
  vim.system({ 'mkdir', '-pv', LAZYPATH .. '/lazy.nvim' })
  vim.system({
    'git',
    'clone',
    LAZYREPO,
    '--filter=blob:none',
    '--branch=stable', -- latest stable release
    LAZYPATH .. '/lazy.nvim',
  }, {}, function(out)
    if out.code ~= 0 then
      vim.api.nvim_echo({
        { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
        { out.stdout,                     'WarningMsg' },
        { out.stderr,                     'WarningMsg' },
        { '\nPress any key to exit...' },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end)
end
vim.opt.rtp:prepend(LAZYPATH .. '/lazy.nvim')

require('lazy').setup({
  spec = {
    { import = 'plugins' },
    { import = 'plugins.filetype' },
  },

  root = LAZYPATH, -- directory where plugins will be installed
  lockfile = LAZYPATH .. '/lazy-lock.json',
  defaults = { lazy = true },

  git = {
    timeout = 600,
    url_format = 'https://github.com/%s.git',
  },
  change_detection = {
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true,
    rtp = {
      reset = true,
      ---@type string[]
      paths = {}, -- add any custom paths here that you want to indluce in the rtp
      ---@type string[] list any plugins you want to disable here
      disabled_plugins = {
        -- 'tohtml',
        -- 'gzip',
        -- 'zip',
        -- 'zipPlugin',
        -- 'tar',
        -- 'tarPlugin',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'shada_plugin',

        'rplugin',
        'luasnip',
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
  profiling = {
    -- Enables extra stats on the debug tab related to the loader cache.
    -- Additionally gathers stats about all package.loaders
    loader = true,
    -- Track each new require in the Lazy profiling tab
    require = true,
  },
})

vim.api.nvim_create_autocmd('User', {
  once = true,
  pattern = 'LazyInstall',
  callback = function()
    local oldcmdheight = vim.opt.cmdheight:get()
    vim.opt.cmdheight = 1
    vim.notify 'Please wait while plugins are installed...'
    vim.cmd.bw()
    vim.opt.cmdheight = oldcmdheight
    vim.tbl_map(function(module)
      pcall(require, module)
    end, { 'nvim-treesitter' })
  end,
})
