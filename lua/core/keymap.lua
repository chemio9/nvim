local is_available = require 'core.utils'.is_available
local map = { i = {}, n = {}, v = {}, t = {},[''] = {} }
-- {{{
if is_available 'smart-splits.nvim' then
  -- Smart Splits
  -- Better window navigation
  map.n['<C-h>'] = { function() require 'smart-splits'.move_cursor_left() end, desc = 'Move to left split' }
  map.n['<C-j>'] = { function() require 'smart-splits'.move_cursor_down() end, desc = 'Move to below split' }
  map.n['<C-k>'] = { function() require 'smart-splits'.move_cursor_up() end, desc = 'Move to above split' }
  map.n['<C-l>'] = { function() require 'smart-splits'.move_cursor_right() end, desc = 'Move to right split' }

  -- Resize with arrows
  map.n['<C-Up>'] = { function() require 'smart-splits'.resize_up() end, desc = 'Resize split up' }
  map.n['<C-Down>'] = { function() require 'smart-splits'.resize_down() end, desc = 'Resize split down' }
  map.n['<C-Left>'] = { function() require 'smart-splits'.resize_left() end, desc = 'Resize split left' }
  map.n['<C-Right>'] = { function() require 'smart-splits'.resize_right() end, desc = 'Resize split right' }
end

map.n['<C-N>'] = { '<cmd>bnext<CR>', desc = 'Next buf' }
map.n['<C-M>'] = { '<cmd>bprevious<CR>', desc = 'Prev buf' }
map.n['<C-M-N>'] = { '<cmd>tabnext<CR>', desc = 'Next tab' }
map.n['<C-M-M>'] = { '<cmd>tabprevious<CR>', desc = 'Prev tab' }

-- Terminal
if is_available 'toggleterm.nvim' then
  map.n['<leader>t'] = { desc = ' Terminal' }
  -- local toggle_term_cmd = astronvim.toggle_term_cmd
  -- if vim.fn.executable "lazygit" == 1 then
  --   maps.n["<leader>gg"] = { function() toggle_term_cmd "lazygit" end, desc = "ToggleTerm lazygit" }
  --   maps.n["<leader>tl"] = { function() toggle_term_cmd "lazygit" end, desc = "ToggleTerm lazygit" }
  -- end
  -- if vim.fn.executable "node" == 1 then
  --   maps.n["<leader>tn"] = { function() toggle_term_cmd "node" end, desc = "ToggleTerm node" }
  -- end
  -- if vim.fn.executable "gdu" == 1 then
  --   maps.n["<leader>tu"] = { function() toggle_term_cmd "gdu" end, desc = "ToggleTerm gdu" }
  -- end
  -- if vim.fn.executable "btm" == 1 then
  --   maps.n["<leader>tt"] = { function() toggle_term_cmd "btm" end, desc = "ToggleTerm btm" }
  -- end
  -- if vim.fn.executable "python" == 1 then
  --   maps.n["<leader>tp"] = { function() toggle_term_cmd "python" end, desc = "ToggleTerm python" }
  -- end
  map.n['<leader>tf'] = { '<cmd>ToggleTerm direction=float<cr>', desc = 'ToggleTerm float' }
  map.n['<leader>th'] = { '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = 'ToggleTerm horizontal split' }
  map.n['<leader>tv'] = { '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'ToggleTerm vertical split' }
  map.n['<F7>'] = { '<cmd>ToggleTerm<cr>', desc = 'Toggle terminal' }
  map.t['<F7>'] = map.n['<F7>']
  map.n['<C-`>'] = map.n['<F7>']
  map.t['<C-`>'] = map.n['<F7>']
end

-- write files with sudo permission
-- this is useful when you forget to use `sudo nvim foo`
map.n['<leader>S'] = { '<cmd>w !sudo tee % >/dev/null<CR>', desc = 'write current file with sudo permission' }

-- use screen line by default
map.n['gj'] = { 'j' }
map.n['gk'] = { 'k' }
map.n['j'] = { "v:count ? 'j' : 'gj'", expr = true, desc = 'Move cursor down' }
map.n['k'] = { "v:count ? 'k' : 'gk'", expr = true, desc = 'Move cursor up' }
map.v['j'] = map.n.j
map.v['k'] = map.n.k

-- modified function keys found with `showkey -a` in the terminal to get key code
-- run `nvim -V3log +quit` and search through the "Terminal info" in the `log` file for the correct keyname
if is_available 'nvim-dap' then
  map.n['<leader>d'] = { desc = " Debugger" }
  map.n['<F5>'] = { function() require 'dap'.continue() end, desc = 'Debugger: Start' }
  map.n['<F17>'] = { function() require 'dap'.terminate() end, desc = 'Debugger: Stop' }      -- Shift+F5
  map.n['<F29>'] = { function() require 'dap'.restart_frame() end, desc = 'Debugger: Restart' } -- Control+F5
  map.n['<F6>'] = { function() require 'dap'.pause() end, desc = 'Debugger: Pause' }
  map.n['<F9>'] = { function() require 'dap'.toggle_breakpoint() end, desc = 'Debugger: Toggle Breakpoint' }
  map.n['<F10>'] = { function() require 'dap'.step_over() end, desc = 'Debugger: Step Over' }
  map.n['<F11>'] = { function() require 'dap'.step_into() end, desc = 'Debugger: Step Into' }
  map.n['<F23>'] = { function() require 'dap'.step_out() end, desc = 'Debugger: Step Out' } -- Shift+F11
  map.n['<leader>db'] = { function() require 'dap'.toggle_breakpoint() end, desc = 'Toggle Breakpoint (F9)' }
  map.n['<leader>dB'] = { function() require 'dap'.clear_breakpoints() end, desc = 'Clear Breakpoints' }
  map.n['<leader>dc'] = { function() require 'dap'.continue() end, desc = 'Start/Continue (F5)' }
  map.n['<leader>di'] = { function() require 'dap'.step_into() end, desc = 'Step Into (F11)' }
  map.n['<leader>do'] = { function() require 'dap'.step_over() end, desc = 'Step Over (F10)' }
  map.n['<leader>dO'] = { function() require 'dap'.step_out() end, desc = 'Step Out (S-F11)' }
  map.n['<leader>dq'] = { function() require 'dap'.close() end, desc = 'Close Session' }
  map.n['<leader>dQ'] = { function() require 'dap'.terminate() end, desc = 'Terminate Session (S-F5)' }
  map.n['<leader>dp'] = { function() require 'dap'.pause() end, desc = 'Pause (F6)' }
  map.n['<leader>dr'] = { function() require 'dap'.restart_frame() end, desc = 'Restart (C-F5)' }
  map.n['<leader>dR'] = { function() require 'dap'.repl.toggle() end, desc = 'Toggle REPL' }

  map.n['<leader>du'] = { function() require 'dapui'.toggle() end, desc = 'Toggle Debugger UI' }
  map.n['<leader>dh'] = { function() require 'dap.ui.widgets'.hover() end, desc = 'Debugger Hover' }
end

-- due to my habit
map['']['<leader>j'] = { function() require 'hop'.hint_words() end, desc = 'jump by words' }
map['']['<leader>J'] = { function() require 'hop'.hint_patterns() end, desc = 'jump by patterns' }
-- }}}

local M = {}
local utils = require 'core.utils'
function M.setup()
  utils.setup_mappings(map)
end

return M
