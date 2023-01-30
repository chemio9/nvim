vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNewFile' }, {
  group = vim.api.nvim_create_augroup('NvimTree', { clear = true }),
  pattern = '*',
  callback = function()
    local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
    if stats and stats.type == 'directory' then
      vim.cmd.NvimTreeOpen()
    end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('yank_highlight', {}),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'PmenuSel', timeout = 600 }
  end,
})
