local conditions = require 'heirline.conditions'
local utils = require 'heirline.utils'
local c = require 'plugins.heirline.components'


local DefaultStatusline = {
  utils.surround({ '', '' }, 'bg_highlight', c.ViMode),
  c.Space, c.WorkDir, c.Space, c.Git, c.Space, c.Diagnostics, c.Align,
  c.FileType, c.Space, c.FileNameBlock, c.Align,
  c.LSPActive, c.Space, c.FileFormat, c.FileEncoding, c.Space, c.Ruler, c.Space, c.ScrollBar,
}

local InactiveStatusline = {
  condition = conditions.is_not_active,
  c.FileType,
  c.Space,
  c.FileName,
  c.Align,
}

local SpecialStatusline = {
  condition = function()
    return conditions.buffer_matches {
      buftype = { 'nofile', 'prompt', 'help', 'quickfix' },
      filetype = { '^git.*', 'fugitive' },
    }
  end,

  c.FileType,
  c.Space,
  c.HelpFileName,
  c.Align,
}

local TerminalStatusline = {
  condition = function()
    return conditions.buffer_matches { buftype = { 'terminal' } }
  end,

  hl = { bg = 'red1' },

  -- Quickly add a condition to the ViMode to only show it when buffer is active!
  { condition = conditions.is_active, c.ViMode, c.Space },
  c.FileType,
  c.Space,
  c.TerminalName,
  c.Align,
}

local StatusLines = {
  hl = function()
    if conditions.is_active() then
      return 'StatusLine'
    else
      return 'StatusLineNC'
    end
  end,

  -- the first statusline with no condition, or which condition returns true is used.
  -- think of it as a switch case with breaks to stop fallthrough.
  fallthrough = false,

  SpecialStatusline,
  TerminalStatusline,
  InactiveStatusline,
  DefaultStatusline,
}

return StatusLines
