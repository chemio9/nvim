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
          require('neo-tree.command').execute { toggle = true }
        end,
        desc = 'Explorer NeoTree (root dir)',
      },
      {
        '<leader>fE',
        function()
          require('neo-tree.command').execute { toggle = true, dir = vim.loop.cwd() }
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
        if stat and stat.type == 'directory' then require 'neo-tree' end
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

  {
    'rolv-apneseth/tfm.nvim',
    cmd = {
      'Tfm',
      'TfmSplit',
      'TfmVsplit',
      'TfmTabedit',
    },
    opts = {
      -- Possible choices: "ranger" | "nnn" | "lf" | "yazi" (default)
      file_manager = 'yazi',
      -- leave to Neo-tree
      replace_netrw = false,
      enable_cmds = true,
      -- Custom keybindings only applied within the TFM buffer
      keybindings = {
        ['<ESC>'] = 'q',
      },
      -- Customise UI. The below options are the default
      ui = {
        border = 'rounded',
        height = 1,
        width = 1,
        x = 0.5,
        y = 0.5,
      },
    },
    keys = {
      {
        '<leader>mo',
        function() require('tfm').open() end,
        desc = 'TFM'
      },
      {
        '<leader>mh',
        function()
          local tfm = require('tfm')
          tfm.open(nil, tfm.OPEN_MODE.split)
        end,
        desc = 'TFM - horizonal split'
      },
      {
        '<leader>mv',
        function()
          local tfm = require('tfm')
          tfm.open(nil, tfm.OPEN_MODE.vsplit)
        end,
        desc = 'TFM - vertical split'
      },
      {
        '<leader>mt',
        function()
          local tfm = require('tfm')
          tfm.open(nil, tfm.OPEN_MODE.tabedit)
        end,
        desc = 'TFM - new tab'
      },
    },
  },

  {
    's1n7ax/nvim-window-picker',
    opts = {
      use_winbar = 'smart',
    },
  },
}
