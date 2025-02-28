local utils = require 'core.utils'
local map = utils.map

utils.map_opt({ silent = true, noremap = true })

-- Diagnsotics
map('n', '<leader>eD', function() require('fzf-lua').diagnostics_workspace() end, { desc = 'Search diagnostics' })
map('n', '<leader>es', function() require('fzf-lua').lsp_document_symbols() end, { desc = 'Search symbols' })
map('n', '<leader>ed',
  function()
    require('trouble').open 'diagnostics'
  end, { desc = 'Diagnostics' })

-- Diagnsotic jump can use `<c-o>` to jump back
map('n', '[e', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
map('n', ']e', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
map('n', '[b', '<cmd>bprevious<CR>', { desc = 'Prev buf' })
map('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buf' })

-- Terminal
-- write files with sudo permission
-- this is useful when you forget to use `sudo nvim foo`
-- TODO: replace with suda.nvim
-- map('n', '<leader>S', { '<cmd>w !sudo tee % >/dev/null<CR>', desc = 'sudo write' })
vim.cmd.cabbrev('w!!', 'w !sudo tee > /dev/null %')

map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { desc = 'Down', expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { desc = 'Up', expr = true, silent = true })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next Search Result' })
map({ 'x', 'o' }, 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next Search Result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev Search Result' })
map({ 'x', 'o' }, 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev Search Result' })

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

map('n', 'H', '0^')
map('n', 'L', '$')

map('n', '<leader>gB', function() require('fzf-lua').git_branches() end, { desc = 'Git branches' })
map('n', '<leader>gC', function() require('fzf-lua').git_commits() end, { desc = 'Git commits' })
map('n', '<leader>gs', function() require('fzf-lua').git_status() end, { desc = 'Git status' })

map('n', 'K',
  function()
    local winid = require('ufo').peekFoldedLinesUnderCursor()
    if not winid then
      vim.lsp.buf.hover()
    end
  end,
  { desc = 'Preview fold or hover' })
