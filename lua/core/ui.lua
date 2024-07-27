local M = {}

function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()

  -- don't use treesitter folds for non-file buffers
  if vim.bo[buf].buftype ~= '' then
    return '0'
  end

  -- as long as we don't have a filetype, don't bother
  -- checking if treesitter is available (it won't)
  if vim.bo[buf].filetype == '' then
    return '0'
  end

  local ok = pcall(vim.treesitter.get_parser, buf)

  if ok then
    return vim.treesitter.foldexpr()
  end
end

return M
