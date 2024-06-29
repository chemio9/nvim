---@type LazySpec[]
return {
  {
    'lewis6991/gitsigns.nvim',
    enabled = vim.fn.executable 'git' == 1,
    ft = 'gitcommit',
    event = 'User File',
    cmd = 'Gitsigns',
    opts = {
      trouble = true,
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '▎' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '▎' },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
    },
    keys = {
      { '<leader>ga', function() require('gitsigns.actions').stage_hunk() end,      desc = 'stage hunk' },
      { '<leader>gd', function() require('gitsigns.actions').preview_hunk() end,    desc = 'preview hunk' },
      { '<leader>gA', function() require('gitsigns.actions').undo_stage_hunk() end, desc = 'undo stage hunk' },
      { '<leader>gn', function() require('gitsigns.actions').next_hunk() end,       desc = 'next hunk' },
      { '<leader>gp', function() require('gitsigns.actions').prev_hunk() end,       desc = 'prev hunk' },
      { '<leader>gr', function() require('gitsigns.actions').reset_hunk() end,      desc = 'prev hunk' },
    },
  },

  {
    'moyiz/git-dev.nvim',
    lazy = true,
    cmd = { 'GitDevOpen', 'GitDevCleanAll' },
    opts = {
      read_only = false,
    },
  },
}
