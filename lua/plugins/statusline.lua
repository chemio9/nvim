---@type LazySpec[]
return {
  {
    'sontungexpt/sttusline',
    branch = 'table_version',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    event = 'BufEnter',
    opts = {
      -- on_attach = function(create_update_group) end

      -- the colors of statusline will be set follow the colors of the active buffer
      -- statusline_color = "#fdff00",
      statusline_color = 'StatusLine',
      disabled = {
        filetypes = {
          -- "NvimTree",
          -- "lazy",
        },
        buftypes = {
          'terminal',
        },
      },
      components = {
        'mode',
        'os-uname',
        'filename',
        'git-branch',
        'git-diff',
        '%=',
        'diagnostics',
        'lsps-formatters',
        'indent',
        'encoding',
        'pos-cursor',
        'pos-cursor-progress',
      },
    },
    config = function(_, opts)
      require('sttusline').setup(opts)
    end,
  }
}
