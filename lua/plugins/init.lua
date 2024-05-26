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

  {
    'nvim-lua/plenary.nvim',
    keys = {
      {
        '<leader>hpb',
        function()
          require('plenary.profile').start('profile.log', { flame = true })
        end,
        desc = 'Begin profiling',
      },
      {
        '<leader>hpe',
        function()
          require('plenary.profile').stop()
        end,
        desc = 'End profiling',
      },
    },
    config = function()
      require('which-key').register({
        ['hp'] = {
          name = '+profile',
        },
      }, { prefix = '<leader>' })
    end,
  },

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

}
