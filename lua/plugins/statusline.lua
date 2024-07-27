---@type LazySpec[]
return {
  {
    'sontungexpt/sttusline',
    branch = 'table_version',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    event = 'VeryLazy',
    opts = {
      -- on_attach = function(create_update_group) end

      -- the colors of statusline will be set follow the colors of the active buffer
      -- statusline_color = "#fdff00",
      statusline_color = 'StatusLine',
      disabled = {
        filetypes = {
          'neo-tree',
          'lazy',
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
        -- 'lsps-formatters',
        'indent',
        'encoding',
        'pos-cursor',
        'pos-cursor-progress',
      },
    },
    config = function(_, opts)
      require('sttusline').setup(opts)
    end,
  },

  {
    'nanozuki/tabby.nvim',
    event = 'VeryLazy',
    dependencies = 'nvim-tree/nvim-web-devicons',
    keys = {
      { '<leader>ta',  ':$tabnew<CR>',  noremap = true, desc = 'New Tab' },
      { '<leader>tc',  ':tabclose<CR>', noremap = true, desc = 'Close Tab' },
      { '<leader>to',  ':tabonly<CR>',  noremap = true, desc = 'Only Tab' },
      { ']t',          ':tabn<CR>',     noremap = true, desc = 'Next Tab' },
      { '[t',          ':tabp<CR>',     noremap = true, desc = 'Prev Tab' },
      { '<leader>tmp', ':-tabmove<CR>', noremap = true, desc = 'Move Tab Prev' },
      { '<leader>tmn', ':+tabmove<CR>', noremap = true, desc = 'Move tab next' },
    },
    config = function()
      vim.o.showtabline = 2

      local theme = {
        fill = 'TabLineFill',
        -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
        head = 'TabLine',
        current_tab = 'TabLineSel',
        tab = 'TabLine',
        win = 'TabLine',
        tail = 'TabLine',
      }
      require('tabby.tabline').set(function(line)
        return {
          {
            { '  ', hl = theme.head },
            line.sep('', theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep('', hl, theme.fill),
              tab.is_current() and '' or '󰆣',
              tab.number(),
              tab.name(),
              tab.close_btn('󰖭'),
              line.sep('', hl, theme.fill),
              hl = hl,
              margin = ' ',
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            return {
              line.sep('', theme.win, theme.fill),
              win.is_current() and '' or '',
              win.buf_name(),
              line.sep('', theme.win, theme.fill),
              hl = theme.win,
              margin = ' ',
            }
          end),
          {
            line.sep('', theme.tail, theme.fill),
            { '  ', hl = theme.tail },
          },
          hl = theme.fill,
        }
      end)
    end,
  },

  {
    'luukvbaal/statuscol.nvim',
    event = 'VeryLazy',
    config = function()
      local builtin = require('statuscol.builtin')
      require('statuscol').setup({
        bt_ignore = { 'terminal' },
        ft_ignore = { 'lazy' },
        relculright = true,
        segments = {
          {
            sign = {
              namespace = { 'gitsign' },
              colwidth = 1,
              wrap = true,
            },
            click = 'v:lua.ScSa',
          },
          { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
          {
            sign = {
              name = { '.*' },
              maxwidth = 2,
              colwidth = 1,
              auto = true,
              wrap = true,
            },
            click = 'v:lua.ScSa',
          },
          {
            text = { builtin.lnumfunc, ' ' },
            condition = { true, builtin.not_empty },
            click = 'v:lua.ScLa',
          },
        },
      })
    end,
  },
}
