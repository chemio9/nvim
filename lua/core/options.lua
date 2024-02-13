---@diagnostic disable: assign-type-mismatch, undefined-field
-- to ignore assigning a value to vim.opt
local o = vim.opt
local g = vim.g

vim.scriptencoding = 'utf-8'
o.iskeyword:append('-')
o.fileencodings = {
  'utf-8',
  'ucs-bom',
  'gb18030',
  'gbk',
  'gb2312',
  'cp936',
  'latin1',
}
o.encoding = 'utf-8'

o.number = true
o.relativenumber = true

o.laststatus = 3
o.startofline = true
o.ignorecase = true
o.smartcase = true
o.copyindent = true -- Copy the previous indentation on autoindenting

o.splitbelow = true
o.splitright = true
o.splitkeep = 'screen'

o.linebreak = true

o.undofile = false
o.swapfile = false

o.scrolloff = 10
o.sidescrolloff = 10

o.signcolumn = 'auto:1-2'

o.maxmempattern = 2000 -- max match pattern
-- o.autochdir = true -- auto change directory to current file
o.autoread = true
o.lazyredraw = true -- true will speed up in macro repeat
o.ttyfast = true    -- true maybe as lazyredraw ? TODO

o.wrap = false
o.mouse = 'a'
o.hidden = true
o.termguicolors = true

-- useful when editing my neovim config :P
o.path:prepend './lua/**'
o.path:append './**'

o.tabstop = 2 -- replace tab as white space
o.expandtab = true
o.shiftwidth = 2
o.softtabstop = 2

o.cursorline = true

o.conceallevel = 2
o.concealcursor = 'nc' -- char will always fold except in insert mode

o.foldenable = false   -- fold
o.foldlevel = 99       -- disable fold for opened file
o.foldminlines = 2     -- 0 means even the child is only one line fold always works
o.foldmethod = 'expr'  -- for most filetype fold by syntax
o.foldexpr = 'nvim_treesitter#foldexpr()'
o.foldnestmax = 5      -- max fold nest

-- Clipboard
o.clipboard:append 'unnamedplus'

o.completeopt = { 'menu', 'menuone', 'noselect' }

o.updatetime = 300

o.shortmess:append { s = true, I = true }
o.backspace:append { 'nostop' }
o.diffopt:append 'linematch:60'

o.fillchars = { eob = ' ' } -- Disable `~` on nonexistent lines
o.history = 100             -- Number of commands to remember in a history table

-- Leader/local leader
g.mapleader = [[ ]]
g.maplocalleader = [[,]]

-- skip remote provider loading
g.loaded_python3_provider = 0
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

