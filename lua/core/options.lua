---@diagnostic disable: assign-type-mismatch, undefined-field
-- to ignore assigning a value to vim.opt

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

vim.opt.laststatus = 3
vim.opt.startofline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.copyindent = true -- Copy the previous indentation on autoindenting

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = 'screen'

vim.opt.linebreak = true

vim.opt.undofile = false
vim.opt.swapfile = false

vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

vim.opt.signcolumn = 'auto:1-2'

vim.opt.maxmempattern = 2000 -- max match pattern
-- o.autochdir = true -- auto change directory to current file
vim.opt.autoread = true
vim.opt.lazyredraw = false -- true will speed up in macro repeat
vim.opt.ttyfast = true     -- true maybe as lazyredraw ? TODO

vim.opt.wrap = false
vim.opt.mouse = 'a'
vim.opt.hidden = true
vim.opt.termguicolors = true

-- useful when editing my neovim config :P
vim.opt.path:prepend './lua/**'
vim.opt.path:append './**'

vim.opt.tabstop = 2 -- replace tab as white space
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.cursorline = false

vim.opt.conceallevel = 2
vim.opt.concealcursor = '' -- never conceal the current line

vim.opt.foldenable = true
vim.opt.foldcolumn = '1'    -- '0' is not bad
vim.opt.foldlevel = 99      -- disable fold for opened file
vim.opt.foldlevelstart = 99
vim.opt.foldminlines = 2    -- 0 means even the child is only one line fold always works
vim.opt.foldmethod = 'expr' -- for most filetype fold by syntax
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldnestmax = 5     -- max fold nest

-- Clipboard
vim.opt.clipboard:append 'unnamedplus'

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

vim.opt.updatetime = 300

vim.opt.shortmess:append { s = true, I = true }
vim.opt.backspace:append { 'nostop' }
vim.opt.diffopt:append 'linematch:60'

vim.opt.fillchars = {
  eob = ' ',
  fold = ' ',
  foldopen = '',
  foldsep = ' ',
  foldclose = ''
} -- Disable `~` on nonexistent lines
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
