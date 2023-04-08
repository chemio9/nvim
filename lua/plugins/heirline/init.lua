return {
  'rebelot/heirline.nvim',
  event = 'BufEnter',
  config = function()
    vim.opt.laststatus = 3
    vim.opt.showmode = false

    local heirline = require 'heirline'
    local utils = require 'heirline.utils'

    heirline.setup {
      statusline = require 'plugins.heirline.statusline',
      tabline = require 'plugins.heirline.tabline',
      winbar = require 'plugins.heirline.winbar',
      -- statuscolumn = '...',
      opts = {
        -- if the callback returns true, the winbar will be disabled for that window
        -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
        disable_winbar_cb = function(args)
          local buf = args.buf
          local buftype = vim.tbl_contains({ 'prompt', 'nofile', 'help', 'quickfix' }, vim.bo[buf].buftype)
          local filetype = vim.tbl_contains({ 'gitcommit', 'fugitive', 'Trouble', 'packer' }, vim.bo[buf].filetype)
          return buftype or filetype
        end,
        colors = {
          none = 'NONE',
          bg_dark = '#1e2030',
          bg = '#222436',
          bg_highlight = '#2f334d',
          terminal_black = '#444a73',
          fg = '#c8d3f5',
          fg_dark = '#828bb8',
          fg_gutter = '#3b4261',
          blue = '#82aaff',
          cyan = '#86e1fc',
          purple = '#fca7ea',
          magenta = '#c099ff',
          orange = '#ff966c',
          yellow = '#ffc777',
          green = '#c3e88d',
          red = '#ff757f',
          red1 = '#c53b53',
          diag_warn = utils.get_highlight 'DiagnosticWarn'.fg,
          diag_error = utils.get_highlight 'DiagnosticError'.fg,
          diag_hint = utils.get_highlight 'DiagnosticHint'.fg,
          diag_info = utils.get_highlight 'DiagnosticInfo'.fg,
          git_del = utils.get_highlight 'diffRemoved'.fg,
          git_add = utils.get_highlight 'diffAdded'.fg,
          git_change = utils.get_highlight 'diffChanged'.fg,
        },
      },
    }

    vim.o.showtabline = 2
    vim.cmd [[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]]
  end,
}
