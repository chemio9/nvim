vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('nvim-tree', { clear = true }),
  pattern = '*',
  callback = function()
    local stats = vim.loop.fs_stat(vim.api.nvim_buf_get_name(0))
    if stats and stats.type == 'directory' then
      vim.cmd.NvimTreeOpen()
    end
    vim.api.nvim_del_augroup_by_name 'nvim-tree'
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('yank_highlight', {}),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'PmenuSel', timeout = 600 }
  end,
})
