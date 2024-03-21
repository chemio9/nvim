local utils = require 'core.utils'
local has = utils.has
local map = utils.map

utils.map_opt({ silent = true })
map('n', '<leader>b', { desc = 'buffer' })
map('n', '<leader>bn', { '<cmd>bnext<CR>', desc = 'Next buf' })
map('n', '<leader>bp', { '<cmd>bprevious<CR>', desc = 'Prev buf' })

-- Terminal
if has 'toggleterm.nvim' then map('n', '<leader>t', { desc = ' Terminal' }) end

-- write files with sudo permission
-- this is useful when you forget to use `sudo nvim foo`
-- TODO: replace with suda.nvim
-- map('n', '<leader>S', { '<cmd>w !sudo tee % >/dev/null<CR>', desc = 'sudo write' })
vim.cmd.cabbrev('w!!', 'w !sudo tee > /dev/null %')

-- use screen line by default
map('n', 'gj', { 'j' })
map('n', 'gk', { 'k' })
map({ 'n', 'v' }, 'j', { "v:count ? 'j' : 'gj'", expr = true, desc = 'Move cursor down' })
map({ 'n', 'v' }, 'k', { "v:count ? 'k' : 'gk'", expr = true, desc = 'Move cursor up' })

map('n', 'H', { '0^' })
map('n', 'L', { '$' })
--
-- modified function keys found with `showkey -a` in the terminal to get key code
-- run `nvim -V3log +quit` and search through the "Terminal info" in the `log` file for the correct keyname
if has 'nvim-dap' then map('n', '<leader>d', { desc = ' Debugger' }) end

if has 'neo-tree.nvim' then map('n', '<leader>F', { '<cmd>Neotree toggle<CR>', desc = 'open Neotree' }) end

if has 'bufdelete.nvim' then map('n', '<leader>q', { '<cmd>Bwipeout<CR>', desc = 'Bwipeout' }) end

map('n', '<leader>g', { desc = '󰊢 Git' })
map('n', '<leader>gB', { function() require('telescope.builtin').git_branches() end, desc = 'Git branches' })
map('n', '<leader>gC', { function() require('telescope.builtin').git_commits() end, desc = 'Git commits' })
map('n', '<leader>gs', { function() require('telescope.builtin').git_status() end, desc = 'Git status' })
map('n', '<leader>ga', { function() require('gitsigns.actions').stage_hunk() end, desc = 'stage hunk' })
map('n', '<leader>gd', { function() require('gitsigns.actions').preview_hunk() end, desc = 'preview hunk' })
map('n', '<leader>gA', { function() require('gitsigns.actions').undo_stage_hunk() end, desc = 'undo stage hunk' })
map('n', '<leader>gn', { function() require('gitsigns.actions').next_hunk() end, desc = 'next hunk' })
map('n', '<leader>gp', { function() require('gitsigns.actions').prev_hunk() end, desc = 'prev hunk' })

map('n', '<leader>f', { desc = '󰍉 Find' })
map('n', '<leader>f<CR>', { function() require('telescope.builtin').resume() end, desc = 'Resume previous search' })
map('n', "<leader>f'", { function() require('telescope.builtin').marks() end, desc = 'Find marks' })
map('n', '<leader>fb', { function() require('telescope.builtin').buffers() end, desc = 'Find buffers' })
map('n', '<leader>fc',
  { function() require('telescope.builtin').grep_string() end, desc = 'Find for word under cursor' })
map('n', '<leader>fC', { function() require('telescope.builtin').commands() end, desc = 'Find commands' })
map('n', '<leader>ff', { function() require('telescope.builtin').find_files() end, desc = 'Find files' })
map('n', '<leader>fF',
  { function() require('telescope.builtin').find_files { hidden = true, no_ignore = true } end, desc = 'Find all files' })
map('n', '<leader>fh', { function() require('telescope.builtin').help_tags() end, desc = 'Find help' })
map('n', '<leader>fk', { function() require('telescope.builtin').keymaps() end, desc = 'Find keymaps' })
map('n', '<leader>fm', { function() require('telescope.builtin').man_pages() end, desc = 'Find man' })
if has 'nvim-notify' then
  map('n', '<leader>fn',
    { function() require('telescope').extensions.notify.notify() end, desc = 'Find notifications' })
end
map('n', '<leader>fo', { function() require('telescope.builtin').oldfiles() end, desc = 'Find history' })
map('n', '<leader>fr', { function() require('telescope.builtin').registers() end, desc = 'Find registers' })
map('n', '<leader>ft',
  { function() require('telescope.builtin').colorscheme { enable_preview = true } end, desc = 'Find themes' })
map('n', '<leader>fw', { function() require('telescope.builtin').live_grep() end, desc = 'Find words' })
map('n', '<leader>fW',
  {
    function()
      require('telescope.builtin').live_grep { additional_args = function(args)
        return vim.list_extend(args,
          { '--hidden', '--no-ignore' })
      end }
    end,
    desc = 'Find words in all files',
  })

local M = {}
function M.setup()
  utils.which_key_register()
end

return M
