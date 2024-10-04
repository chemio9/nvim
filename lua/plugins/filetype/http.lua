---@type LazySpec[]|LazySpec
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
    keys = {
      { '<localleader>p', function() require('kulala').jump_prev() end, noremap = true, silent = true,  ft = 'http' },
      { '<localleader>n', function() require('kulala').jump_next() end, noremap = true, silent = true,  ft = 'http' },
      { '<localleader>r', function() require('kulala').run() end,       noremap = true, silent = true,  ft = 'http' },
    },
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
