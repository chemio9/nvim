-- vim: fdm=marker
--- Table based API for setting keybindings {{{
-- @param map_table A nested table where the first key is the vim mode, the second key is the key to map, and the value is the function to set the mapping to
-- @param base A base set of options to set on every keybinding
local function setup_mappings(map_table, base)
  local wk_avail, wk = pcall(require, "which-key")
  -- iterate over the first keys for each mode
  for mode, maps in pairs(map_table) do
    -- iterate over each keybinding set in the current mode
    for keymap, options in pairs(maps) do
      -- build the options for the command accordingly
      if options then
        local cmd = options
        local keymap_opts = base or {}
        if type(options) == "table" then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend("force", options, keymap_opts)
          keymap_opts[1] = nil
        end
        if type(options) == "table" and options.name then
          if wk_avail then
            -- if options have name, then use which-key register
            keymap_opts.mode = mode
            wk.register({ [keymap] = options }, keymap_opts)
          end
        else
          -- extend the keybinding options with the base provided and set the mapping
          vim.keymap.set(mode, keymap, cmd, keymap_opts)
        end
      end
    end
  end
end
-- }}}

local map = { i = {}, n = {}, v = {}, t = {}, [''] = {} }
-- {{{
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

-- Terminal
map.n['<leader>t'] = { name = 'Terminal' }
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
map.n['<leader>d'] = { name = 'Debugger' }
map.n['<F5>'] = { function() require 'dap'.continue() end, desc = 'Debugger: Start' }
map.n['<F17>'] = { function() require 'dap'.terminate() end, desc = 'Debugger: Stop' } -- Shift+F5
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

map.n['<C-w>w'] = { function() require 'window-picker'.pick_window() end, desc = 'Pick a window' }
map.n['<C-w><C-w>'] = map.n['<C-w>w']

-- due to my habit
map['']['<leader>j'] = { function() require 'hop'.hint_words() end, desc = 'jump by words' }
map['']['<leader>J'] = { function() require 'hop'.hint_patterns() end, desc = 'jump by patterns' }
-- }}}

-- lsp map
local lmap = { i = {}, n = {}, v = {}, t = {}, [''] = {} }
-- {{{

lmap.n['<leader>c'] = { name = 'Code' }
-- Code action
lmap.n['<leader>ca'] = { '<cmd>Lspsaga code_action<CR>', desc = 'run code action' }
lmap.v['<leader>ca'] = lmap.n['<leader>ca']
-- Rename
lmap.n['<leader>cr'] = { '<cmd>Lspsaga rename<CR>', desc = 'rename symbols' }
lmap.n['<leader>cf'] = {
  function()
    vim.lsp.buf.format { async = true }
  end,
  desc = 'format',
}
-- Outline
lmap.n['<leader>co'] = { '<cmd>Lspsaga outline<CR>', desc = 'symbols outline' }

lmap.n['gh'] = { '<cmd>Lspsaga lsp_finder<CR>', desc = 'find references' }
lmap.n['gp'] = { '<cmd>Lspsaga peek_definition<CR>', desc = 'peek definition' }
lmap.n['gD'] = { vim.lsp.buf.declaration, desc = 'go to declaration' }
lmap.n['gd'] = { vim.lsp.buf.definition, desc = 'go to definition' }
lmap.n['gi'] = { vim.lsp.buf.implementation, desc = 'go to implementation' }
lmap.n['gt'] = { vim.lsp.buf.type_definition, desc = 'go to type definition' }
lmap.n['K'] = { vim.lsp.buf.signature_help, desc = 'signature help' }

-- Diagnsotics
lmap.n['<leader>e'] = { name = 'diagnostic' }
lmap.n['<leader>ef'] = { vim.diagnostic.open_float, desc = 'diagnostics in float' }
lmap.n['<leader>eq'] = { vim.diagnostic.setloclist, desc = 'diagnostics in location list' }
-- Diagnsotic jump can use `<c-o>` to jump back
lmap.n['[e'] = { '<cmd>Lspsaga diagnostic_jump_prev<CR>', desc = 'previous diagnostic' }
lmap.n[']e'] = { '<cmd>Lspsaga diagnostic_jump_next<CR>', desc = 'next diagnostic' }
-- Only jump to error
lmap.n['[E'] = { function() require 'lspsaga.diagnostic'.goto_prev { severity = vim.diagnostic.severity.ERROR } end,
  desc = 'previous error', }
lmap.n[']E'] = { function() require 'lspsaga.diagnostic'.goto_next { severity = vim.diagnostic.severity.ERROR } end,
  desc = 'next error', }

-- Mappings.
-- See `:help vim.lsp.*` for documentation on any of the below functions
lmap.n['<leader>w'] = { name = 'workspace' }
lmap.n['<leader>wa'] = { vim.lsp.buf.add_workspace_folder, desc = 'add workspace folder' }
lmap.n['<leader>wr'] = { vim.lsp.buf.remove_workspace_folder, desc = 'remove workspace folder' }
lmap.n['<leader>wl'] = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
  desc = 'list workspace folders', }
--
-- }}}

local M = {}
function M.setup()
  setup_mappings(map)
end

---@diagnostic disable-next-line: unused-local
function M.attach_lsp(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  setup_mappings(lmap, bufopts)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

return M
