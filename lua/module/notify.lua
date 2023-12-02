local notify = require 'notify'
notify.setup {
  max_width = 40,
  on_open = function(win)
    vim.api.nvim_win_set_config(win, { zindex = 175 })
    if not package.loaded['nvim-treesitter'] then pcall(require, 'nvim-treesitter') end

    local buf = vim.api.nvim_win_get_buf(win)
    if not pcall(vim.treesitter.start, buf, 'markdown') then vim.bo[buf].syntax = 'markdown' end

    vim.wo[win].conceallevel = 3
    vim.wo[win].wrap = true
    vim.wo[win].spell = false
  end,
}
vim.notify = notify
