local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
autocmd('FileType', {
  pattern = 'http',
  group = augroup('FtLocalKeymaps', {}),
  callback = function(ev)
    vim.keymap.set('n', '<localleader>p', function() require('kulala').jump_prev() end, { noremap = true, silent = true })
    vim.keymap.set('n', '<localleader>n', function() require('kulala').jump_next() end, { noremap = true, silent = true })
    vim.keymap.set('n', '<localleader>r', function() require('kulala').run() end, { noremap = true, silent = true })
  end,
})

return {
  {
    'mistweaverco/kulala.nvim',
    ft = 'http',
    init = function()
      vim.filetype.add {
        extension = {
          http = 'http',
        },
      }
    end,
    config = function()
      -- Setup is required, even if you don't pass any options
      require('kulala').setup({
        -- default_view, body or headers
        default_view = 'body',
        -- dev, test, prod, can be anything
        -- see: https://learn.microsoft.com/en-us/aspnet/core/test/http-files?view=aspnetcore-8.0#environment-files
        default_env = 'dev',
        -- enable/disable debug mode
        debug = false,
      })
    end,
  },
}
