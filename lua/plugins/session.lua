---@type LazySpec
return {
  'stevearc/resession.nvim',
  lazy = false,
  opts = {
    extensions = {
      quickfix = {},
      scope = {},   -- add scope.nvim extension
    },
    -- override default filter
    buf_filter = function(bufnr)
      local buftype = vim.bo[bufnr].buftype
      if buftype == 'help' then
        return true
      end
      if buftype ~= '' and buftype ~= 'acwrite' then
        return false
      end
      if vim.api.nvim_buf_get_name(bufnr) == '' then
        return false
      end

      -- this is required for scope.nvim, since the default filter skips nobuflisted buffers
      return true
    end,
  },
  keys = {
    { '<leader>ss', function() require('resession').save() end },
    { '<leader>sl', function() require('resession').load() end },
    { '<leader>sd', function() require('resession').delete() end },
  },
}
