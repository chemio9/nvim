---@diagnostic disable: assign-type-mismatch, undefined-field
-- to ignore assigning a value to vim.opt

-- 1MB
vim.g.bigfile_size = 1024 * 1024

vim.scriptencoding = 'utf-8'
vim.opt.iskeyword:append('-')
vim.opt.fileencodings = {
  'utf-8',
  'ucs-bom',
  'gb18030',
  'gbk',
  'gb2312',
  'cp936',
  'latin1',
}
vim.opt.encoding = 'utf-8'

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.laststatus = 3 -- global status line
vim.opt.startofline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.copyindent = true -- Copy the previous indentation on autoindenting
vim.opt.shiftround = true -- Round indent
vim.opt.tabstop = 2
vim.opt.expandtab = true  -- replace tab as white space
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = 'screen'

vim.opt.linebreak = true

vim.opt.undofile = false
vim.opt.swapfile = false

vim.opt.signcolumn = 'auto:1-2'

vim.opt.maxmempattern = 2000 -- max match pattern
vim.opt.autochdir = true     -- auto change directory to current file
vim.opt.autoread = true
vim.opt.lazyredraw = false   -- true will speed up in macro repeat
vim.opt.ttyfast = true       -- true maybe as lazyredraw ? TODO

vim.opt.wrap = false
vim.opt.mouse = 'a'
vim.opt.hidden = true
vim.opt.termguicolors = true

vim.opt.path:prepend './lua/**'
vim.opt.path:append './**'

vim.opt.cursorline = false

vim.opt.conceallevel = 2
vim.opt.concealcursor = '' -- never conceal the current line

vim.opt.foldenable = true
vim.opt.foldcolumn = '1' -- '0' is not bad
vim.opt.foldlevel = 99   -- disable fold for opened file
vim.opt.foldlevelstart = 99
vim.opt.foldminlines = 2 -- 0 means even the child is only one line fold always works
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = "v:lua.require'core.ui'.foldexpr()"
vim.opt.foldtext = ''
vim.opt.foldnestmax = 5 -- max fold nest

-- Clipboard
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus' -- Sync with system clipboard

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.wildmode = 'longest:full,full' -- Command-line completion mode
vim.opt.formatoptions = 'jcroqlnt'     -- tcqj

vim.opt.updatetime = 300

vim.opt.spelloptions:append('camel')
vim.opt.spelllang = { 'en', 'cjk' }

vim.opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode

vim.opt.backspace:append { 'nostop' }
vim.opt.diffopt:append 'linematch:60'

vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.smoothscroll = true

vim.opt.shortmess:append { s = true, I = true, c = true, C = true }
vim.opt.fillchars = {
  diff = '╱',
  eob = ' ', -- Disable `~` on nonexistent lines
  fold = ' ',
  foldopen = '',
  foldsep = ' ',
  foldclose = '',
}
vim.opt.history = 100 -- Number of commands to remember in a history table

vim.opt.viewoptions = { 'folds', 'slash', 'unix' }
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize' }

vim.opt.jumpoptions = { 'stack', 'view' }

-- Leader/local leader
vim.g.mapleader = [[ ]]
vim.g.maplocalleader = [[,]]

-- skip remote provider loading
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.filetype.add {
  extension = {
    mdx = 'mdx',
    tsx = 'typescriptreact',
    jsx = 'javascriptreact',
    webc = 'html',
  },
}

-- Fix markdown indentation settings
-- see 'ft-markdown-plugin'
vim.g.markdown_recommended_style = 0
