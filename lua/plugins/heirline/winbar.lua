local conditions = require 'heirline.conditions'
local utils = require 'heirline.utils'
local c = require 'plugins.heirline.components'
local WinBars = {
  fallthrough = false,
  {
    -- Hide the winbar for special buffers
    condition = function()
      return conditions.buffer_matches {
        buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
        filetype = { '^git.*', 'fugitive' },
      }
    end,
    init = function()
      vim.opt_local.winbar = nil
    end,
  },
  {
    -- A special winbar for terminals
    condition = function()
      return conditions.buffer_matches { buftype = { 'terminal' } }
    end,
    utils.surround({ '', '' }, 'float_bg', {
      c.FileType,
      c.Space,
      c.TerminalName,
    }),
  },
  {
    -- An inactive winbar for regular files
    condition = function()
      return not conditions.is_active()
    end,
    utils.surround({ '', '' }, 'bg_statusline',
      { hl = { fg = 'gray', force = true }, c.FileNameBlock }),
  },
  -- A winbar for regular files
  utils.surround({ '', '' }, 'bg', c.FileNameBlock),
}

return WinBars
