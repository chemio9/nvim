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


--- nvim-origami is no longer compatible with nvim-ufo so I steal it here. :)
--- {{{
local function normal(cmdStr) vim.cmd.normal { cmdStr, bang = true } end

local config = { hOnlyOpensOnFirstColumn = false }

-- `h` closes folds when at the beginning of a line.
local function h()
	local count = vim.v.count1 -- saved as `normal` affects it
	for _ = 1, count, 1 do
		local col = vim.api.nvim_win_get_cursor(0)[2]
		local textBeforeCursor = vim.api.nvim_get_current_line():sub(1, col)
		local onIndentOrFirstNonBlank = textBeforeCursor:match("^%s*$")
			and not config.hOnlyOpensOnFirstColumn
		local firstChar = col == 0 and config.hOnlyOpensOnFirstColumn
		if onIndentOrFirstNonBlank or firstChar then
			local wasFolded = pcall(normal, "zc")
			if not wasFolded then normal("h") end
		else
			normal("h")
		end
	end
end

-- `l` on a folded line opens the fold.
local function l()
	local count = vim.v.count1 -- count needs to be saved due to `normal` affecting it
	for _ = 1, count, 1 do
		local isOnFold = vim.fn.foldclosed(".") > -1 ---@diagnostic disable-line: param-type-mismatch
		local action = isOnFold and "zo" or "l"
		pcall(normal, action)
	end
end

vim.keymap.set( "n", "h", function() h() end, { desc = "Origami h" })
vim.keymap.set( "n", "l", function() l() end, { desc = "Origami l" })

-- disable auto-open when searching, since we take care of that in a better way
vim.opt.foldopen:remove { "search" }

local ns = vim.api.nvim_create_namespace("auto_pause_folds")

vim.on_key(function(char)
	if vim.g.scrollview_refreshing then return end -- FIX https://github.com/dstein64/nvim-scrollview/issues/88#issuecomment-1570400161
	local key = vim.fn.keytrans(char)
	local isCmdlineSearch = vim.fn.getcmdtype():find("[/?]") ~= nil
	local isNormalMode = vim.api.nvim_get_mode().mode == "n"

	local searchStarted = (key == "/" or key == "?") and isNormalMode
	local searchConfirmed = (key == "<CR>" and isCmdlineSearch)
	local searchCancelled = (key == "<Esc>" and isCmdlineSearch)
	if not (searchStarted or searchConfirmed or searchCancelled or isNormalMode) then return end
	local foldsArePaused = not (vim.opt.foldenable:get())
	-- works for RHS, therefore no need to consider remaps
	local searchMovement = vim.tbl_contains({ "n", "N", "*", "#" }, key)

	local pauseFold = (searchConfirmed or searchStarted or searchMovement) and not foldsArePaused
	local unpauseFold = foldsArePaused and (searchCancelled or not searchMovement)
	if pauseFold then
		vim.opt_local.foldenable = false
	elseif unpauseFold then
		vim.opt_local.foldenable = true
		pcall(vim.cmd.foldopen, { bang = true }) -- after closing folds, keep the *current* fold open
	end
end, ns)
--- }}}
