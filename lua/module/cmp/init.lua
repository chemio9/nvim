-- Set up nvim-cmp.
local cmp = require 'cmp'

-- General configurations
local config = {}

local kind = require 'module.cmp.kind'
kind.update(config)

local luasnip = require 'luasnip'
config.snippet = {
  expand = function(args)
    luasnip.lsp_expand(args.body)
  end,
}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and
      vim.api.nvim_buf_get_lines(0, line - 1, line, true)
      [1]:sub(col, col):match '%s' == nil
end
config.mapping = {
  ['<Up>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
  ['<Down>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
  ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
  ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
  -- ['<C-j>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
  -- ['<C-k>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
  ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
  ['<C-y>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
  ['<C-e>'] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
  ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
  ['<CR>'] = cmp.mapping.confirm { select = true },
  ['<Tab>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
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
  { name = 'luasnip', priority = 750 },
}, {
  { name = 'buffer', priority = 500 },
  { name = 'path', priority = 250 },
})

-- cmp_conf.view = {
--   entries = { name = 'custom', selection_order = 'near_cursor' },
-- }

config.preselect = cmp.PreselectMode.None


cmp.setup(config)

-- Set configuration for specific filetype.
cmp.setup.filetype('text', {
  sources = {
    { name = 'calc' },
  },
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- TODO: You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  }),
})

-- Use buffer source for `/` and `?`
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' },
  },
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})
