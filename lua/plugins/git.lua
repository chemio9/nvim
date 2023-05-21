return {
  {
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    config = true,
  },

  {
    'lewis6991/gitsigns.nvim',
    enabled = vim.fn.executable 'git' == 1,
    ft = 'gitcommit',
    event = 'User GitFile',
    cmd = 'Gitsigns',
    opts = {
      trouble = true,
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '▎' },
        topdelete = { text = '契' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      signcolumn = true,   -- Toggle with `:Gitsigns toggle_signs`
      numhl = false,       -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false,      -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false,   -- Toggle with `:Gitsigns toggle_word_diff`
    },
  },
}
