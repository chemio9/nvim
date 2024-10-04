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

local lazy = require('lazy')
lazy.setup({
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
  ---@diagnostic disable-next-line: assign-type-mismatch
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

local Loader = require('lazy.core.loader')
local Util = require('lazy.core.util')
local key = require('lazy.core.handler.keys')
---@diagnostic disable-next-line: duplicate-set-field
key._add = function(keys)
  local lhs = keys.lhs
  local opts = keys.opts(keys)

  ---@param buf? number
  local function add(buf)
    if keys.is_nop(keys) then
      return key:_set(keys, buf)
    end

    vim.api.nvim_create_autocmd('SafeState', {
      group = vim.api.nvim_create_augroup('LazyKeys', { clear = true }),
      callback = function()
        vim.keymap.set(keys.mode, lhs, function()
          local plugins = key.active[keys.id]

          -- always delete the mapping immediately to prevent recursive mappings
          key:_del(keys)
          key.active[keys.id] = nil

          if plugins then
            local name = keys.to_string(keys)
            Util.track({ keys = name })
            Loader.load(plugins, { keys = name })
            Util.track()
          end

          if keys.mode:sub(-1) == 'a' then
            lhs = lhs .. '<C-]>'
          end
          local feed = vim.api.nvim_replace_termcodes('<Ignore>' .. lhs, true, true, true)
          -- insert instead of append the lhs
          vim.api.nvim_feedkeys(feed, 'i', false)
        end, {
          desc = opts.desc,
          nowait = opts.nowait,
          -- we do not return anything, but this is still needed to make operator pending mappings work
          expr = true,
          buffer = buf,
        })
      end,
    })
  end

  -- buffer-local mappings
  if keys.ft then
    vim.api.nvim_create_autocmd('FileType', {
      pattern = keys.ft,
      callback = function(event)
        if key.active[keys.id] and not keys.is_nop(keys) then
          add(event.buf)
        else
          -- Only create the mapping if its managed by lazy
          -- otherwise the plugin is supposed to manage it
          key:_set(keys, event.buf)
        end
      end,
    })
  else
    add()
  end
end
