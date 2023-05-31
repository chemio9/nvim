local c = require 'plugins.heirline.components'
local utils = require 'heirline.utils'

-- this is the default function used to retrieve buffers
local get_bufs = function()
  return vim.tbl_filter(function(bufnr)
    return vim.api.nvim_buf_get_option(bufnr, 'buflisted')
  end, vim.api.nvim_list_bufs())
end

-- initialize the buflist cache
local buflist_cache = {}

-- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
vim.api.nvim_create_autocmd({ 'VimEnter', 'UIEnter', 'BufAdd', 'BufDelete' }, {
  callback = function()
    vim.schedule(function()
      local buffers = get_bufs()
      for i, v in ipairs(buffers) do
        buflist_cache[i] = v
      end
      for i = #buffers + 1, #buflist_cache do
        buflist_cache[i] = nil
      end

      -- check how many buffers we have and set showtabline accordingly
      if #buflist_cache > 1 then
        vim.o.showtabline = 2 -- always
      else
        vim.o.showtabline = 1 -- only when #tabpages > 1
      end
    end)
  end,
})

local TablinePicker = {
  condition = function(self)
    return self._show_picker
  end,
  init = function(self)
    local bufname = vim.api.nvim_buf_get_name(self.bufnr)
    bufname = vim.fn.fnamemodify(bufname, ':t')
    local label = bufname:sub(1, 1)
    local i = 2
    while self._picker_labels[label] do
      if i > #bufname then
        break
      end
      label = bufname:sub(i, i)
      i = i + 1
    end
    self._picker_labels[label] = self.bufnr
    self.label = label
  end,
  provider = function(self)
    return self.label
  end,
  hl = { fg = 'red', bold = true },
}

local BufferLine = utils.make_buflist(
  { TablinePicker, c.TablineBufferBlock },
  { provider = ' ', hl = { fg = 'gray' } },
  { provider = ' ', hl = { fg = 'gray' } },
  -- out buf_func simply returns the buflist_cache
  function()
    return buflist_cache
  end,
  -- no cache, as we're handling everything ourselves
  false
)


vim.keymap.set('n', 'gbp', function()
  local tabline = require 'heirline'.tabline
  local buflist = tabline[3]._buflist[1]
  buflist._picker_labels = {}
  buflist._show_picker = true
  vim.cmd.redrawtabline()
  local char = vim.fn.getcharstr()
  local bufnr = buflist._picker_labels[char]
  if bufnr then
    vim.api.nvim_win_set_buf(0, bufnr)
  end
  buflist._show_picker = false
  vim.cmd.redrawtabline()
end)

return { c.TabLineOffset, BufferLine, c.TabPages }
