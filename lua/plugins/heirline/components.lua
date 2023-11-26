local conditions = require 'heirline.conditions'
local utils = require 'heirline.utils'
local icons = require 'core.icons'
local M = {}
M.Align = { provider = '%=' }
M.Space = { provider = ' ' }

M.ViMode = {
  -- get vim current mode, this information will be required by the provider
  -- and the highlight functions, so we compute it only once per component
  -- evaluation and store it as a component attribute
  init = function(self)
    self.mode = vim.fn.mode(1) -- :h mode()
  end,
  -- Now we define some dictionaries to map the output of mode() to the
  -- corresponding string and color. We can put these into `static` to compute
  -- them at initialisation time.
  static = {
    mode_names = {
      -- change the strings if you like it vvvvverbose!
      n = 'N',
      no = 'N?',
      nov = 'N?',
      noV = 'N?',
      ['no\22'] = 'N?',
      niI = 'Ni',
      niR = 'Nr',
      niV = 'Nv',
      nt = 'Nt',
      v = 'V',
      vs = 'Vs',
      V = 'V_',
      Vs = 'Vs',
      ['\22'] = '^V',
      ['\22s'] = '^V',
      s = 'S',
      S = 'S_',
      ['\19'] = '^S',
      i = 'I',
      ic = 'Ic',
      ix = 'Ix',
      R = 'R',
      Rc = 'Rc',
      Rx = 'Rx',
      Rv = 'Rv',
      Rvc = 'Rv',
      Rvx = 'Rv',
      c = 'C',
      cv = 'Ex',
      r = '...',
      rm = 'M',
      ['r?'] = '?',
      ['!'] = '!',
      t = 'T',
    },
    mode_colors = {
      n = 'red',
      i = 'green',
      v = 'cyan',
      V = 'cyan',
      ['\22'] = 'cyan',
      c = 'orange',
      s = 'purple',
      S = 'purple',
      ['\19'] = 'purple',
      R = 'orange',
      r = 'orange',
      ['!'] = 'red',
      t = 'red',
    },
  },
  -- We can now access the value of mode() that, by now, would have been
  -- computed by `init()` and use it to index our strings dictionary.
  -- note how `static` fields become just regular attributes once the
  -- component is instantiated.
  -- To be extra meticulous, we can also add some vim statusline syntax to
  -- control the padding and make sure our string is always at least 2
  -- characters long. Plus a nice Icon.
  provider = function(self)
    return icons.Evil .. '%2(' .. self.mode_names[self.mode] .. '%)'
  end,
  -- Same goes for the highlight. Now the foreground will change according to the current mode.
  hl = function(self)
    local mode = self.mode:sub(1, 1) -- get only the first mode character
    return { fg = self.mode_colors[mode], bold = true }
  end,
  -- Re-evaluate the component only on ModeChanged event!
  -- Also allows the statusline to be re-evaluated when entering operator-pending mode
  update = {
    'ModeChanged',
    pattern = '*:*',
    callback = function()
      vim.cmd 'redrawstatus'
    end,
  },
}


M.FileNameBlock = {
  -- let's first set up some attributes needed by this component and it's children
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
}
-- We can now define some children separately and add them later

M.FileIcon = {
  init = function(self)
    local filename = self.filename
    local extension = vim.fn.fnamemodify(filename, ':e')
    self.icon, self.icon_color = require 'nvim-web-devicons'.get_icon_color(filename, extension, { default = true })
  end,
  provider = function(self)
    return self.icon and (self.icon .. ' ')
  end,
  hl = function(self)
    return { fg = self.icon_color }
  end,
}

M.FileName = {
  condition = function()
    local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
    return not (buftype == 'terminal' or buftype == 'nofile')
  end,
  init = function(self)
    self.lfilename = vim.fn.fnamemodify(self.filename, ':.')
    if self.lfilename == '' then self.lfilename = '[No Name]' end
  end,
  hl = { fg = utils.get_highlight 'Directory'.fg },

  flexible = 2,

  {
    provider = function(self)
      return self.lfilename
    end,
  },
  {
    provider = function(self)
      return vim.fn.pathshorten(self.lfilename)
    end,
  },
}

M.FileFlags = {
  {
    condition = function()
      return vim.bo.modified
    end,
    provider = '[+]',
    hl = { fg = 'green' },
  },
  {
    condition = function()
      return not vim.bo.modifiable or vim.bo.readonly
    end,
    provider = '',
    hl = { fg = 'orange' },
  },
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

M.FileNameModifer = {
  hl = function()
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      return { fg = 'cyan', bold = true, force = true }
    end
  end,
}

-- let's add the children to our FileNameBlock component
M.FileNameBlock = utils.insert(
  M.FileNameBlock,
  M.FileIcon,
  utils.insert(M.FileNameModifer, M.FileName), -- a new table where FileName is a child of FileNameModifier
  M.FileFlags,
  { provider = '%<' }                          -- this means that the statusline is cut here when there's not enough space
)

M.FileType = {
  provider = function()
    return string.upper(vim.bo.filetype)
  end,
  hl = { fg = utils.get_highlight 'Type'.fg, bold = true },
}

M.FileEncoding = {
  provider = function()
    local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc -- :h 'enc'
    return enc ~= 'utf-8' and enc:upper()
  end,
}

M.FileFormat = {
  provider = function()
    local fmt = vim.bo.fileformat
    return fmt ~= 'unix' and fmt:upper()
  end,
}

M.FileSize = {
  condition = function()
    local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
    return not (buftype == 'terminal' or buftype == 'nofile')
  end,
  provider = function()
    -- stackoverflow, compute human readable file size
    local suffix = { 'b', 'k', 'M', 'G', 'T', 'P', 'E' }
    local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
    fsize = (fsize < 0 and 0) or fsize
    if fsize < 1024 then
      return fsize .. suffix[1]
    end
    local i = math.floor((math.log(fsize) / math.log(1024)))
    return string.format('%.2g%s', fsize / math.pow(1024, i), suffix[i + 1])
  end,
}

M.Ruler = {
  -- %l = current line number
  -- %L = number of lines in the buffer
  -- %c = column number
  -- %P = percentage through file of displayed window
  provider = '%3(%l%):%2c %P',
}

M.ScrollBar = {
  static = {
    sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' },
    -- Another variant, because the more choice the better.
    -- sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
  },
  provider = function(self)
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
    return string.rep(self.sbar[i], 2)
  end,
  hl = { fg = 'blue' },
}

M.LSPActive = {
  condition = conditions.lsp_attached,
  update = { 'LspAttach', 'LspDetach' },

  on_click = {
    callback = function()
      vim.defer_fn(function()
        vim.cmd 'LspInfo'
      end, 100)
    end,
    name = 'heirline_LSP',
  },

  flexible = 1,

  {
    -- You can keep it simple,
    provider = ' [LSP]',

    hl = { fg = 'green', bold = true },
    -- Or complicate things a bit and get the servers names
    -- provider  = function()
    --     local names = {}
    --     for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
    --         table.insert(names, server.name)
    --     end
    --     return " [" .. table.concat(names, " ") .. "]"
    -- end,
  },

  {
    provider = ''
  },
}

M.Diagnostics = {
  condition = conditions.has_diagnostics,

  static = {
    error_icon = require 'core.icons'.DiagnosticError,
    warn_icon = require 'core.icons'.DiagnosticWarn,
    info_icon = require 'core.icons'.DiagnosticInfo,
    hint_icon = require 'core.icons'.DiagnosticHint,
  },

  on_click = {
    callback = function()
      require 'trouble'.toggle { mode = 'document_diagnostics' }
      -- or
      -- vim.diagnostic.setqflist()
    end,
    name = 'heirline_diagnostics',
  },

  init = function(self)
    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  end,

  update = { 'DiagnosticChanged', 'BufEnter' },

  flexible = 1,

  {

    {
      provider = function(self)
        -- 0 is just another output, we can decide to print it or not!
        return self.errors > 0 and (self.error_icon .. self.errors .. ' ')
      end,
      hl = 'DiagnosticError',
    },
    {
      provider = function(self)
        return self.warnings > 0 and (self.warn_icon .. self.warnings .. ' ')
      end,
      hl = 'DiagnosticWarn',
    },
    {
      provider = function(self)
        return self.info > 0 and (self.info_icon .. self.info .. ' ')
      end,
      hl = 'DiagnosticInfo',
    },
    {
      provider = function(self)
        return self.hints > 0 and (self.hint_icon .. self.hints)
      end,
      hl = 'DiagnosticHint',
    },
  },

  {
    provider = '',
  },
}

M.Git = {
  condition = conditions.is_git_repo,

  init = function(self)
    ---@diagnostic disable-next-line: undefined-field
    self.status_dict = vim.b.gitsigns_status_dict
    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
  end,

  hl = { fg = 'orange' },

  flexible = 1,

  {

    {
      -- git branch name
      provider = function(self)
        return ' ' .. self.status_dict.head
      end,
      hl = { bold = true },
    },
    -- You could handle delimiters, icons and counts similar to Diagnostics
    {
      condition = function(self)
        return self.has_changes
      end,
      provider = '('
    },
    {
      provider = function(self)
        local count = self.status_dict.added or 0
        return count > 0 and ('+' .. count)
      end,
      hl = { fg = 'git_add' },
    },
    {
      provider = function(self)
        local count = self.status_dict.removed or 0
        return count > 0 and ('-' .. count)
      end,
      hl = { fg = 'git_delete' },
    },
    {
      provider = function(self)
        local count = self.status_dict.changed or 0
        return count > 0 and ('~' .. count)
      end,
      hl = { fg = 'git_change' },
    },
    {
      condition = function(self)
        return self.has_changes
      end,
      provider = ')',
    },
  },

  {
    -- only display an icon when there is not enough space
    provider = ' ',
    hl = { bold = true },
  },
}

M.WorkDir = {
  init = function(self)
    self.icon = (vim.fn.haslocaldir(0) == 1 and 'l' or 'g') .. ' ' .. ' '
    local cwd = vim.fn.getcwd(0)
    self.cwd = vim.fn.fnamemodify(cwd, ':~')
  end,
  hl = { fg = 'blue', bold = true },

  flexible = 2,

  {
    -- evaluates to the full-lenth path
    provider = function(self)
      local trail = self.cwd:sub(-1) == '/' and '' or '/'
      return self.icon .. self.cwd .. trail .. ' '
    end,
  },
  {
    -- evaluates to the shortened path
    provider = function(self)
      local cwd = vim.fn.pathshorten(self.cwd)
      local trail = self.cwd:sub(-1) == '/' and '' or '/'
      return self.icon .. cwd .. trail .. ' '
    end,
  },
  {
    -- evaluates to "", hiding the component
    provider = '',
  },
}

M.SearchCount = {
  condition = function()
    return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
  end,
  init = function(self)
    local ok, search = pcall(vim.fn.searchcount)
    if ok and search.total then
      self.search = search
    end
  end,
  provider = function(self)
    local search = self.search
    return string.format('[%d/%d]', search.current, math.min(search.total, search.maxcount))
  end,
}

M.MacroRec = {
  condition = function()
    return vim.fn.reg_recording() ~= '' and vim.o.cmdheight == 0
  end,
  provider = ' ',
  hl = { fg = 'orange', bold = true },
  utils.surround({ '[', ']' }, nil, {
    provider = function()
      return vim.fn.reg_recording()
    end,
    hl = { fg = 'green', bold = true },
  }),
  update = {
    'RecordingEnter',
    'RecordingLeave',
    -- redraw the statusline on recording events
    -- Note: this is only required for Neovim < 0.9.0. Newer versions of
    -- Neovim ensure `statusline` is redrawn on those events.
    callback = vim.schedule_wrap(function()
      vim.cmd 'redrawstatus'
    end),
  },
}

M.SearchResults = {
  condition = function(self)
    local lines = vim.api.nvim_buf_line_count(0)
    if lines > 50000 then return end

    local query = vim.fn.getreg '/'
    if query == '' then return end

    if query:find '@' then return end

    local search_count = vim.fn.searchcount { recompute = 1, maxcount = -1 }
    local active = false
    if vim.v.hlsearch and vim.v.hlsearch == 1 and search_count.total > 0 then
      active = true
    end
    if not active then return end

    query = query:gsub([[^\V]], '')
    query = query:gsub([[\<]], ''):gsub([[\>]], '')

    self.query = query
    self.count = search_count
    return true
  end,
  {
    provider = function(self)
      return table.concat {
        ' ', self.query, ' ', self.count.current, '/', self.count.total, ' ',
      }
    end,
    hl = nil, -- your highlight goes here
  },
  M.Space,    -- A separator after, if section is active, without highlight.
}

M.TerminalName = {
  -- we could add a condition to check that buftype == 'terminal'
  -- or we could do that later (see #conditional-statuslines below)
  provider = function()
    local tname, _ = vim.api.nvim_buf_get_name(0):gsub('.*:', '')
    return ' ' .. tname
  end,
  hl = { fg = 'blue', bold = true },
}

M.HelpFileName = {
  condition = function()
    return vim.bo.filetype == 'help'
  end,
  provider = function()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ':t')
  end,
  hl = { fg = 'blue' },
}

M.TablineBufnr = {
  provider = function(self)
    return tostring(self.bufnr) .. '. '
  end,
  hl = 'Comment',
}

-- we redefine the filename component, as we probably only want the tail and not the relative path
M.TablineFileName = {
  provider = function(self)
    -- self.filename will be defined later, just keep looking at the example!
    local filename = self.filename
    filename = filename == '' and '[No Name]' or vim.fn.fnamemodify(filename, ':t')
    return filename
  end,
  hl = function(self)
    return { bold = self.is_active or self.is_visible, italic = true }
  end,
}

-- this looks exactly like the FileFlags component that we saw in
-- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
-- also, we are adding a nice icon for terminal buffers.
M.TablineFileFlags = {
  {
    condition = function(self)
      return vim.api.nvim_buf_get_option(self.bufnr, 'modified')
    end,
    provider = '[+]',
    hl = { fg = 'green' },
  },
  {
    condition = function(self)
      return not vim.api.nvim_buf_get_option(self.bufnr, 'modifiable')
          or vim.api.nvim_buf_get_option(self.bufnr, 'readonly')
    end,
    provider = function(self)
      if vim.api.nvim_buf_get_option(self.bufnr, 'buftype') == 'terminal' then
        return '  '
      else
        return ''
      end
    end,
    hl = { fg = 'orange' },
  },
}

-- Here the filename block finally comes together
M.TablineFileNameBlock = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
  end,
  hl = function(self)
    if self.is_active then
      return 'TabLineSel'
      -- why not?
      -- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
      --     return { fg = "gray" }
    else
      return 'TabLine'
    end
  end,
  on_click = {
    callback = function(_, minwid, _, button)
      if (button == 'm') then -- close on mouse middle click
        vim.api.nvim_buf_delete(minwid, { force = false })
      else
        vim.api.nvim_win_set_buf(0, minwid)
      end
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = 'heirline_tabline_buffer_callback',
  },
  M.TablineBufnr,
  M.FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
  M.TablineFileName,
  M.TablineFileFlags,
}

-- a nice "x" button to close the buffer
M.TablineCloseButton = {
  condition = function(self)
    return not vim.api.nvim_buf_get_option(self.bufnr, 'modified')
  end,
  { provider = ' ' },
  {
    provider = '',
    hl = { fg = 'gray' },
    on_click = {
      callback = function(_, minwid)
        vim.api.nvim_buf_delete(minwid, { force = false })
      end,
      minwid = function(self)
        return self.bufnr
      end,
      name = 'heirline_tabline_close_buffer_callback',
    },
  },
}

-- The final touch!
M.TablineBufferBlock = utils.surround({ ' ', ' |' }, function(self)
  if self.is_active then
    return utils.get_highlight 'TabLineSel'.bg
  else
    return utils.get_highlight 'TabLine'.bg
  end
end, { M.TablineFileNameBlock, M.TablineCloseButton })

-- and here we go
M.BufferLine = utils.make_buflist(
  M.TablineBufferBlock,
  { provider = '', hl = { fg = 'gray' } }, -- left truncation, optional (defaults to "<")
  { provider = '', hl = { fg = 'gray' } } -- right trunctation, also optional (defaults to ...... yep, ">")
-- by the way, open a lot of buffers and try clicking them ;)
)

M.TabLineOffset = {
  condition = function(self)
    local win = vim.api.nvim_tabpage_list_wins(0)[1]
    local bufnr = vim.api.nvim_win_get_buf(win)
    self.winid = win

    if vim.bo[bufnr].filetype == 'neo-tree' then
      self.title = 'neo-tree'
      return true
      -- elseif vim.bo[bufnr].filetype == "TagBar" then
      --     ...
    end
  end,

  provider = function(self)
    local title = self.title
    local width = vim.api.nvim_win_get_width(self.winid)
    local pad = math.ceil((width - #title) / 2)
    return string.rep(' ', pad) .. title .. string.rep(' ', pad)
  end,

  hl = function(self)
    if vim.api.nvim_get_current_win() == self.winid then
      return 'TablineSel'
    else
      return 'Tabline'
    end
  end,
}

M.Tabpage = {
  provider = function(self)
    return '%' .. self.tabnr .. 'T ' .. self.tabpage .. ' %T'
  end,
  hl = function(self)
    if not self.is_active then
      return 'TabLine'
    else
      return 'TabLineSel'
    end
  end,
}

M.TabpageClose = {
  provider = '%999X  %X',
  hl = 'TabLine',
}

M.TabPages = {
  -- only show this component if there's 2 or more tabpages
  condition = function()
    return #vim.api.nvim_list_tabpages() >= 2
  end,
  { provider = '%=' },
  utils.make_tablist(M.Tabpage),
  M.TabpageClose,
}

return M
