local conditions = require 'heirline.conditions'
local utils = require 'heirline.utils'
local statusline = require 'plugins.heirline.statusline'
local WinBars = {
  fallthrough = false,
  { -- Hide the winbar for special buffers
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
  { -- A special winbar for terminals
    condition = function()
      return conditions.buffer_matches { buftype = { 'terminal' } }
    end,
    utils.surround({ '', '' }, 'dark_red', {
      statusline.components.FileType,
      statusline.components.Space,
      statusline.components.TerminalName,
    }),
  },
  { -- An inactive winbar for regular files
    condition = function()
      return not conditions.is_active()
    end,
    utils.surround({ '', '' }, 'bg_highlight',
                   { hl = { fg = 'gray', force = true }, statusline.components.FileNameBlock }),
  },
  -- A winbar for regular files
  utils.surround({ '', '' }, 'bg_highlight', statusline.components.FileNameBlock),
}

return WinBars
