local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local utils = require('core.utils')

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
autocmd({ "BufReadPost", "BufNewFile" }, {
  group = augroup("file_user_events", { clear = true }),
  callback = function(args)
    if not (vim.fn.expand "%" == "" or vim.api.nvim_get_option_value("buftype", { buf = args.buf }) == "nofile") then
      utils.event "File"
      if utils.cmd('git -C "' .. vim.fn.expand "%:p:h" .. '" rev-parse', false) then utils.event "GitFile" end
    end
  end,
})
