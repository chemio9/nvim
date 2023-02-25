local utils = require 'heirline.utils'
local c = require 'plugins.heirline.components'
return {
  utils.surround({ '', '' }, 'bg_highlight', { c.FileFlags, c.ViMode }),
  { c.Space, hl = { bg = 'bg' } },
  c.WorkDir,
  { c.Space, hl = { bg = 'bg' } },
  c.Diagnostics,
  c.Align,
  c.FileNameBlock,
  { c.Space, hl = { bg = 'bg' } },
  c.FileSize,
  c.Align,
  utils.surround({ '', '' }, 'bg_highlight', { c.SearchResults, c.Ruler, c.Space, c.ScrollBar }),
}
