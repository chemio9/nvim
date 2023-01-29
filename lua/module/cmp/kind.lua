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
      local item = lspkind.cmp_format {
        maxwidth = 60, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        preset = 'codicons',
        mode = 'symbol_text',
        menu = {
          buffer = '[Buf]',
          nvim_lsp = '[LSP]',
          luasnip = '[Snip]',
          nvim_lua = '[Lua]',
          latex_symbols = '[Tex]',
          path = '[Path]',
        },
      } (entry, vim_item)
      if vim.tbl_contains({ 'path' }, entry.source.name) then
        local icon, hl_group = icons.get_icon(entry:get_completion_item().label)
        if icon then
          item.kind = icon .. ' File'
          item.kind_hl_group = hl_group
        end
      end
      return item
    end,
  }
end

return {
  update = update,
}
