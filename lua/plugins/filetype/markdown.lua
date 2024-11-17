---@type LazySpec[]
return {
  {
    'ellisonleao/glow.nvim',
    ft = 'markdown',
    keys = {
      {
        '<localleader>p',
        '<cmd>Glow<CR>',
        noremap = true,
        silent = true,
        desc = 'Preview markdown',
        ft = 'markdown',
      },
    },
    config = true,
  },

  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    keys = {
      {
        '<localleader>t',
        '<cmd>RenderMarkdown toggle<CR>',
        noremap = true,
        silent = true,
        desc = 'Toggle Markdown Preview',
        ft = 'markdown',
      },
    },
    opts = {
      anti_conceal = {
        -- This enables hiding any added text on the line the cursor is on
        enabled = true,
        -- Number of lines above cursor to show
        above = 2,
        -- Number of lines below cursor to show
        below = 2,
      },
      code = {
        width = 'block',
      },
      dash = {
        width = 80,
      },
      pipe_table = {
        style = 'normal',
      },
    },
    specs = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },

  {
    'Kicamon/markdown-table-mode.nvim',
    ft = 'markdown',
    config = true,
  },

}
