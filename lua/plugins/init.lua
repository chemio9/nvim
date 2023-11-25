---@type LazySpec[]
return {
  {
    'akinsho/toggleterm.nvim',
    cmd = {
      'ToggleTerm',
      'ToggleTermToggleAll',
      'ToggleTermSetName',
      'ToggleTermSendVisualLines',
      'ToggleTermSendVisualSelection',
    },
    keys = {
      { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>',              desc = 'ToggleTerm float' },
      { '<leader>th', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = 'ToggleTerm horizontal split' },
      { '<leader>tv', '<cmd>ToggleTerm size=80 direction=vertical<cr>',   desc = 'ToggleTerm vertical split' },
      {
        '<F7>',
        '<cmd>ToggleTerm<cr>',
        desc = 'Toggle terminal',
        mode = { 't', 'n' },
      },
    },
    config = true,
  },

  -- window managing
  {
    'mrjones2014/smart-splits.nvim',
    opts = {
      ignored_filetypes = {
        'nofile',
        'quickfix',
        'qf',
        'prompt',
      },
      ignored_buftypes = { 'nofile' },
    },

    keys = {
      { '<C-h>',     function() require 'smart-splits'.move_cursor_left() end,  desc = 'Move to left split' },
      { '<C-j>',     function() require 'smart-splits'.move_cursor_down() end,  desc = 'Move to below split' },
      { '<C-k>',     function() require 'smart-splits'.move_cursor_up() end,    desc = 'Move to above split' },
      { '<C-l>',     function() require 'smart-splits'.move_cursor_right() end, desc = 'Move to right split' },
      { '<C-Up>',    function() require 'smart-splits'.resize_up() end,         desc = 'Resize split up' },
      { '<C-Down>',  function() require 'smart-splits'.resize_down() end,       desc = 'Resize split down' },
      { '<C-Left>',  function() require 'smart-splits'.resize_left() end,       desc = 'Resize split left' },
      { '<C-Right>', function() require 'smart-splits'.resize_right() end,      desc = 'Resize split right' },
    },
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
    cmd = 'Alpha',
    config = function()
      require 'module.alpha'
    end,
  },

  -- file explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    cmd = 'Neotree',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      {
        '<leader>fe',
        function()
          require 'neo-tree.command'.execute { toggle = true }
        end,
        desc = 'Explorer NeoTree (root dir)',
      },
      {
        '<leader>fE',
        function()
          require 'neo-tree.command'.execute { toggle = true, dir = vim.loop.cwd() }
        end,
        desc = 'Explorer NeoTree (cwd)',
      },
    },
    deactivate = function()
      vim.cmd [[Neotree close]]
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        ---@diagnostic disable-next-line: param-type-mismatch
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require 'neo-tree'
        end
      end
    end,
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = {
          enabled = false,
        },
      },
      window = {
        mappings = {
          ['<space>'] = 'none',
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
      },
    },
  },

  -- {
  --   's1n7ax/nvim-window-picker',
  --   opts = {
  --     use_winbar = 'smart',
  --   },
  -- },

}
