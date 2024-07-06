local hasGit = vim.fn.executable 'git' == 1

---@type LazySpec[]
return {
  {
    'lewis6991/gitsigns.nvim',
    enabled = hasGit,
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
      { '<leader>gA', function() require('gitsigns.actions').undo_stage_hunk() end, desc = 'undo stage hunk' },
      { '<leader>gd', function() require('gitsigns.actions').preview_hunk() end,    desc = 'diff hunk' },
      { '<leader>gj', function() require('gitsigns.actions').nav_hunk('next') end,  desc = 'next hunk' },
      { '<leader>gk', function() require('gitsigns.actions').nav_hunk('last') end,  desc = 'prev hunk' },
      { '<leader>gr', function() require('gitsigns.actions').reset_hunk() end,      desc = 'reset hunk' },
    },
  },

  {
    'moyiz/git-dev.nvim',
    enabled = hasGit,
    lazy = true,
    cmd = { 'GitDevOpen', 'GitDevCleanAll' },
    opts = {
      read_only = false,
    },
  },

  {
    'chrisgrieser/nvim-tinygit',
    enabled = hasGit,
    dependencies = 'stevearc/dressing.nvim',
    opts = {
      commitMsg = {
        spellcheck = true,
      },
    },
    keys = {
      { '<leader>gc', function() require('tinygit').smartCommit() end,                   desc = 'commit' },
      { '<leader>gp', function() require('tinygit').push() end,                          desc = 'push' },
      { '<leader>gp', function() require('tinygit').push({ forceWithLease = true }) end, desc = 'push (force with lease)' },
      {
        '<leader>gf',
        function()
          -- options show default values
          require('tinygit').fixupCommit {
            selectFromLastXCommits = 15,
            squashInstead = false, -- my habit
            autoRebase = false,
          }
        end,
        desc = 'fixup commit',
      },
    },
  },

  {
    'SuperBo/fugit2.nvim',
    enabled = hasGit,
    opts = {
      width = 100,
      height = "80%",
      -- external_diffview = true, -- tell fugit2 to use diffview.nvim instead of builtin implementation.
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      {
        'chrisgrieser/nvim-tinygit', -- optional: for Github PR view
        dependencies = { 'stevearc/dressing.nvim' },
      },
    },
    cmd = { 'Fugit2', 'Fugit2Diff', 'Fugit2Graph', "Fugit2Blame" },
    keys = {
      { '<leader>F', mode = 'n', '<cmd>Fugit2<cr>' },
    },
  },
}
