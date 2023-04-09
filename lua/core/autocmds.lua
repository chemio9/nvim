local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local utils = require 'core.utils'

autocmd('FileType', {
  desc = 'Make q close help, man, quickfix, dap floats',
  group = augroup('q_close_windows', { clear = true }),
  pattern = { 'qf', 'help', 'man', 'dap-float' },
  callback = function(event)
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true, nowait = true })
  end,
})

autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = augroup('highlightyank', { clear = true }),
  pattern = '*',
  callback = function() vim.highlight.on_yank { higroup = 'PmenuSel', timeout = 600 } end,
})

autocmd({ 'BufEnter', 'BufNewFile' }, {
  group = augroup('NvimTree', { clear = true }),
  pattern = '*',
  callback = function()
    local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
    if stats and stats.type == 'directory' then
      vim.cmd.NvimTreeOpen(vim.api.nvim_buf_get_name(0))
    end
  end,
})

local group_name = augroup('alpha_settings', { clear = true })
autocmd('User', {
  desc = 'Disable status and tablines for alpha',
  group = group_name,
  pattern = 'AlphaReady',
  callback = function()
    local prev_showtabline = vim.opt.showtabline
    local prev_status = vim.opt.laststatus
    vim.opt.laststatus = 0
    vim.opt.showtabline = 0
    vim.opt_local.winbar = nil
    autocmd('BufUnload', {
      pattern = '<buffer>',
      callback = function()
        vim.opt.laststatus = prev_status
        vim.opt.showtabline = prev_showtabline
      end,
    })
  end,
})
autocmd('VimEnter', {
  desc = 'Start Alpha when vim is opened with no arguments',
  group = group_name,
  callback = function()
    local should_skip = false
    ---@diagnostic disable: param-type-mismatch
    if vim.fn.argc() > 0 or vim.fn.line2byte '$' ~= -1 or not vim.o.modifiable then
      should_skip = true
    else
      for _, arg in pairs(vim.v.argv) do
        if arg == '-b' or arg == '-c' or vim.startswith(arg, '+') or arg == '-S' then
          should_skip = true
          break
        end
      end
    end
    if not should_skip then require 'alpha'.start(true, require 'alpha'.default_config) end
  end,
})

autocmd({ 'BufReadPost', 'BufNewFile' }, {
  group = augroup('file_user_events', { clear = true }),
  callback = function(args)
    if not (vim.fn.expand '%' == '' or vim.api.nvim_get_option_value('buftype', { buf = args.buf }) == 'nofile') then
      utils.event 'File'
      if utils.cmd('git -C "' .. vim.fn.expand '%:p:h' .. '" rev-parse', false) then utils.event 'GitFile' end
    end
  end,
})
