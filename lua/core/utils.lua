local M = {}

---@diagnostic disable: redefined-local
---@param plugin string
---@param sync? boolean
function M.loadPlugin(plugin, sync)
  if sync == nil then
    sync = false
  end
  -- force = true ==> sync load
  require 'lazy.core.loader'.load(plugin, { cmd = 'Lazy load' }, { force = sync })
end

-- vim: fdm=marker
--- Table based API for setting keybindings {{{
-- @param map_table A nested table where the first key is the vim mode, the second key is the key to map, and the value is the function to set the mapping to
-- @param base A base set of options to set on every keybinding
function M.setup_mappings(map_table, base)
  local wk_avail, wk = pcall(require, 'which-key')
  -- iterate over the first keys for each mode
  for mode, maps in pairs(map_table) do
    -- iterate over each keybinding set in the current mode
    for keymap, options in pairs(maps) do
      -- build the options for the command accordingly
      if options then
        local cmd = options
        local keymap_opts = base or {}
        if type(options) == 'table' then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend('force', options, keymap_opts)
          keymap_opts[1] = nil
        end
        if type(options) == 'table' and options.name then
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

function M.event(ev)
  vim.schedule(function() vim.api.nvim_exec_autocmds("User", { pattern = ev }) end)
end

--- Run a shell command and capture the output and if the command succeeded or failed
-- @param cmd the terminal command to execute
-- @param show_error boolean of whether or not to show an unsuccessful command as an error to the user
-- @return the result of a successfully executed command or nil
function M.cmd(cmd, show_error)
  if vim.fn.has "win32" == 1 then cmd = { "cmd.exe", "/C", cmd } end
  local result = vim.fn.system(cmd)
  local success = vim.api.nvim_get_vvar "shell_error" == 0
  if not success and (show_error == nil or show_error) then
    vim.api.nvim_err_writeln("Error running command: " .. cmd .. "\nError message:\n" .. result)
  end
  return success and result:gsub("[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "") or nil
end

--- A helper function to wrap a module function to require a plugin before running
-- @param plugin the plugin string to call `require("lazy").load` with
-- @param module the system module where the functions live (e.g. `vim.ui`)
-- @param func_names a string or a list like table of strings for functions to wrap in the given module (e.g. `{ "ui", "select }`)
function M.load_plugin_with_func(plugin, module, func_names)
  if type(func_names) == "string" then func_names = { func_names } end
  for _, func in ipairs(func_names) do
    local old_func = module[func]
    module[func] = function(...)
      module[func] = old_func
      require("lazy").load { plugins = { plugin } }
      module[func](...)
    end
  end
end

return M
