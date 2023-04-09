local lspconfig = require 'lspconfig'
local M = {}

function M.setup(c)
  -- TODO: cannot complete plugins
  require 'neodev'.setup {
    settings = {
      Lua = {
        workspace = {
          library = { '' },
        },
      },
      format = {
        enable = true,
        -- Put format options here
        -- NOTE: the value should be STRING!!
        defaultConfig = {
          indent_style = 'space',
          indent_size = '2',
        },
      },
      library = {
        enabled = true,                -- when not enabled, neodev will not change any settings to the LSP server
        -- these settings will be used for your Neovim config directory
        runtime = true,                -- runtime path
        types = true,                  -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
        plugins = { 'heirline.nvim' }, -- installed opt or start plugins in packpath
      },
      setup_jsonls = true,             -- configures jsonls to provide completion for project specific .luarc.json files
      lspconfig = true,
    },
  }
  lspconfig.lua_ls.setup {
    on_attach = c,
  }
end

return M
