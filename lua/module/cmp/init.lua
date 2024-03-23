local cmp = require 'cmp'
local icons = require 'nvim-web-devicons'
local lspkind = require 'lspkind'
local luasnip = require 'luasnip'
local smartTab = require 'smart-tab'

local function jumpable()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  local cur_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  -- before cursor is blank
  -- when you need to insert tab before text. avoid smartTab take you outside
  return cur_line:sub(1, col):match('%S') ~= nil
end
---@type cmp.ConfigSchema
local config = {}

config.window = {
  completion = cmp.config.window.bordered(),
  documentation = cmp.config.window.bordered(),
}

config.formatting = {
  format = function(entry, vim_item)
    -- provide a completion_item in this style:
    --    completion_text [icon] [kind] [source]
    --  e.g.
    --    |completion    Text [LSP]|
    local item = lspkind.cmp_format {
      maxwidth = 55,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
      preset = 'codicons',
      mode = 'symbol',
      symbol_map = { Codeium = '' },
      menu = {
        buffer = '[Buf]',
        nvim_lsp = '[LSP]',
        luasnip = '[Snip]',
        nvim_lua = '[Lua]',
        latex_symbols = '[Tex]',
        path = '[Path]',
        codeium = '[Code]',
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

config.snippet = {
  expand = function(args)
    luasnip.lsp_expand(args.body)
  end,
}

config.mapping = {
  ['<Up>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
  ['<Down>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
  -- ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
  -- ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
  -- ['<C-j>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
  -- ['<C-k>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
  ['<C-e>'] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
  ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
  ['<CR>'] = cmp.mapping.confirm {},
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif jumpable() then
      smartTab.smart_tab()
    else
      fallback()
    end
  end, { 'i', 's' }),

  ['<S-Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { 'i', 's' }),
}

config.sources = cmp.config.sources({
  { name = 'nvim_lsp', priority = 1000 },
  { name = 'codeium',  priority = 999 },
  { name = 'luasnip',  priority = 750 },
}, {
  { name = 'path',   priority = 1200 },
  { name = 'buffer', priority = 500 },
  { name = 'calc' },
})

config.view = {
  entries = { name = 'custom', selection_order = 'near_cursor' },
}

config.preselect = cmp.PreselectMode.None

cmp.setup(config)
-- Set configuration for specific filetype.

cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})
-- `:` cmdline setup.
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' },
      },
    },
  }),
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- TODO: You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  }),
})

cmp.setup.filetype('neorg', {
  sources = { name = 'neorg' },
})
