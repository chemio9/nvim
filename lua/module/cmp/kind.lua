local function update(config)
  local cmp = require 'cmp'
  config.window = {
    -- completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  }

  local lspkind = require 'lspkind'
  local icons = require 'nvim-web-devicons'
  config.formatting = {
    format = function(entry, vim_item)
      if vim.tbl_contains({ 'path' }, entry.source.name) then
        local icon, hl_group = icons.get_icon(entry:get_completion_item().label)
        if icon then
          vim_item.kind = icon
          vim_item.kind_hl_group = hl_group
          vim_item.menu = '[File]'
          return vim_item
        end
      end
      return lspkind.cmp_format {
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        preset = 'codicons',
        mode = 'symbol',
        menu = {
          buffer = '[Buffer]',
          nvim_lsp = '[LSP]',
          luasnip = '[LuaSnip]',
          nvim_lua = '[Lua]',
          latex_symbols = '[Latex]',
          path = '[Folder]',
        },
      } (entry, vim_item)
    end,
  }
end

return {
  update = update,
}
