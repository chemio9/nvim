local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local utils = require 'core.utils'

autocmd('BufWinEnter', {
  desc = 'Make q close help, man, quickfix, dap floats',
  group = augroup('q_close_windows', { clear = true }),
  callback = function(args)
    local buftype = vim.api.nvim_get_option_value('buftype', { buf = args.buf })
    if vim.tbl_contains({ 'help', 'nofile', 'quickfix' }, buftype) and vim.fn.maparg('q', 'n') == '' then
      vim.keymap.set('n', 'q', '<cmd>close<cr>', {
        desc = 'Close window',
        buffer = args.buf,
        silent = true,
        nowait = true,
      })
    end
  end,
})

autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  group = augroup('highlightyank', { clear = true }),
  pattern = '*',
  callback = function() vim.highlight.on_yank {} end,
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
    local should_skip
    local lines = vim.api.nvim_buf_get_lines(0, 0, 2, false)
    if
        vim.fn.argc() > 0                                                                                    -- don't start when opening a file
        or #lines > 1                                                                                        -- don't open if current buffer has more than 1 line
        or (#lines == 1 and lines[1]:len() > 0)                                                              -- don't open the current buffer if it has anything on the first line
        or #vim.tbl_filter(function(bufnr) return vim.bo[bufnr].buflisted end, vim.api.nvim_list_bufs()) > 1 -- don't open if any listed buffers
        or not vim.o.modifiable                                                                              -- don't open if not modifiable
    then
      should_skip = true
    else
      for _, arg in pairs(vim.v.argv) do
        if arg == '-b' or arg == '-c' or vim.startswith(arg, '+') or arg == '-S' then
          should_skip = true
          break
        end
      end
    end
    if should_skip then return end
    require 'alpha'.start(true, require 'alpha'.default_config)
    vim.schedule(function() vim.cmd.doautocmd 'FileType' end)
  end,
})

autocmd({ 'BufReadPost', 'BufNewFile' }, {
  group = augroup('file_user_events', { clear = true }),
  callback = function(args)
    if not (vim.fn.expand '%' == '' or vim.api.nvim_get_option_value('buftype', { buf = args.buf }) == 'nofile') then
      utils.event 'File'
      if utils.cmd({ 'git', '-C', '"' .. vim.fn.expand '%:p:h' .. '"', 'rev-parse' }, false) then utils.event 'GitFile' end
    end
  end,
})
