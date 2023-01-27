return {
  {
    'akinsho/toggleterm.nvim',
    -- tag = '*',
    cmd = {
      'ToggleTerm',
      'ToggleTermToggleAll',
      'ToggleTermSetName',
      'ToggleTermSendVisualLines',
      'ToggleTermSendVisualSelection',
    },
    config = true,
  },

  {
    'kylechui/nvim-surround',
    keys = { 'ys', 'ds', 'cs' },
    -- tag = '*', -- Use for stability; omit to use `main` branch for the latest features
    config = true,
  },

  -- window managing
  {
    'mrjones2014/smart-splits.nvim',
    config = function()
      require 'module.smart-splits'
    end,
  },

  {
    'max397574/better-escape.nvim',
    event = 'InsertCharPre',
    config = true,
  },

  {
    'folke/zen-mode.nvim',
    cmd = {
      'ZenMode',
    },
    opts = {
      window = {
        backdrop = 1,
      },
    },
  },

  'nvim-lua/plenary.nvim',

  { 'famiu/bufdelete.nvim', cmd = { 'Bdelete', 'Bwipeout' } },

  {
    'sindrets/diffview.nvim',
    cmd = {
      'DiffviewOpen',
      'DiffviewLog',
      'DiffviewClose',
      'DiffviewRefresh',
      'DiffviewFocusFiles',
      'DiffviewToggleFiles',
      'DiffviewFileHistory',
    },
    config = true,
  },

  {
    'goolord/alpha-nvim',
    cond = function()
      local should_load = true
      ---@diagnostic disable-next-line: param-type-mismatch
      if vim.fn.argc() > 0 or vim.fn.line2byte '$' ~= -1 or not vim.o.modifiable then
        should_load = false
      else
        for _, arg in pairs(vim.v.argv) do
          if arg == '-b' or arg == '-c' or vim.startswith(arg, '+') or
              arg == '-S' then
            should_load = false
            break
          end
        end
      end
      return should_load
    end,
    lazy = false,
    cmd = 'Alpha',
    config = function()
      require 'module.alpha'
    end,
  },

  {
    'nvim-tree/nvim-tree.lua',
    tag = 'nightly', -- updated every week. (issue #1193)
    cmd = {
      'NvimTreeOpen',
      'NvimTreeClose',
      'NvimTreeFocus',
      'NvimTreeResize',
      'NvimTreeToggle',
      'NvimTreeRefresh',
      'NvimTreeCollapse',
      'NvimTreeFindFile',
      'NvimTreeClipboard',
      'NvimTreeFindFileToggle',
      'NvimTreeCollapseKeepBuffers',
    },
    config = function()
      require 'module.tree'
    end,
  },

  'nvim-tree/nvim-web-devicons',

  {
    'jghauser/mkdir.nvim',
    init = function()
      vim.cmd [[
        augroup MkdirRun
        autocmd!
        autocmd BufWritePre * lua require('mkdir').run()
        augroup END
      ]]
    end,
  },

  {
    's1n7ax/nvim-window-picker',
    opts = {
      use_winbar = 'smart',
    },
    config = function(_, opts) require 'window-picker'.setup(opts) end,
  },

  {
    'rainbowhxch/accelerated-jk.nvim',
    event = 'VimEnter',
    config = function()
      vim.api.nvim_set_keymap('n', 'j', '<Plug>(accelerated_jk_gj)', {})
      vim.api.nvim_set_keymap('n', 'k', '<Plug>(accelerated_jk_gk)', {})
    end,
  },

  {
    'saifulapm/chartoggle.nvim',
    event = 'InsertCharPre',
    opts = {
      leader = '<localleader>', -- you can use any key as Leader
      keys = { ',', ';' }, -- Which keys will be toggle end of the line
    },
  },

  {
    'phaazon/hop.nvim',
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end,
  },
}
-- vim: fdm=marker
