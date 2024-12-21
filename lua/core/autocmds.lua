local utils = require 'core.utils'
local autocmd, augroup = utils.autocmd, utils.augroup

-- Check if we need to reload the file when it changed
autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime'),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

-- resize splits if window got resized
autocmd({ 'VimResized' }, {
  group = augroup('resize_splits'),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

autocmd('BufWritePre', {
  group = augroup('Mkdir'),
  desc = 'auto create dir when not exists',
  callback = function(event)
    -- This handles URLs using netrw. See ':help netrw-transparent' for details.
    if event.match:match('^%w%w+:[\\/][\\/]') then
      return
    end

    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

autocmd('BufWinEnter', {
  desc = 'close some buftypes with <q>',
  group = augroup('q_close_windows'),
  callback = function(event)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = event.buf })
    if vim.tbl_contains({ 'help', 'nofile', 'quickfix' }, buftype) and vim.fn.maparg('q', 'n') == '' then
      vim.bo[event.buf].buflisted = false
      vim.keymap.set('n', 'q', '<cmd>close<cr>', {
        desc = 'Close window',
        buffer = event.buf,
        silent = true,
        nowait = true,
      })
    end
  end,
})

-- wrap and check for spell in text filetypes
autocmd('FileType', {
  group = augroup('wrap_spell'),
  pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files, really annoying
autocmd({ 'FileType' }, {
  group = augroup('json_conceal'),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = augroup('highlightyank'),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- local Event = require('lazy.core.handler.event')
-- Event.mappings.File = { id = 'File', event = 'User', pattern = 'File' }
autocmd({ 'BufReadPost', 'BufNewFile', 'BufWritePre' }, {
  group = augroup('file_user_events'),
  callback = function(args)
    if not (vim.fn.expand '%' == '' or vim.api.nvim_get_option_value('buftype', { buf = args.buf }) == 'nofile') then
      utils.event 'File'
    end
  end,
})
