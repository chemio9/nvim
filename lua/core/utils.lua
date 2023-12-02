local M = {}

--- Call function if a condition is met
---@param func function The function to run
---@param condition boolean # Whether to run the function or not
---@return any|nil result # the result of the function running or nil
function M.conditional_func(func, condition, ...)
  -- if the condition is true or no condition is provided, evaluate the function with the rest of the parameters and return the result
  if condition and type(func) == 'function' then return func(...) end
end

--- Register queued which-key mappings
function M.which_key_register()
  if M.which_key_queue then
    local wk_avail, wk = pcall(require, 'which-key')
    if wk_avail then
      for mode, registration in pairs(M.which_key_queue) do
        wk.register(registration, { mode = mode })
      end
      M.which_key_queue = nil
    end
  end
end

--- Table based API for setting keybindings
---@param map_table table A nested table where the first key is the vim mode, the second key is the key to map, and the value is the function to set the mapping to
---@param base? table A base set of options to set on every keybinding
function M.setup_mappings(map_table, base)
  -- iterate over the first keys for each mode
  base = base or {}
  for mode, maps in pairs(map_table) do
    -- iterate over each keybinding set in the current mode
    for keymap, options in pairs(maps) do
      -- build the options for the command accordingly
      if options then
        local cmd = options
        local keymap_opts = base
        if type(options) == 'table' then
          cmd = options[1]
          keymap_opts = vim.tbl_deep_extend('force', keymap_opts, options)
          keymap_opts[1] = nil
        end
        if not cmd or keymap_opts.name then -- if which-key mapping, queue it
          if not M.which_key_queue then M.which_key_queue = {} end
          if not M.which_key_queue[mode] then M.which_key_queue[mode] = {} end
          M.which_key_queue[mode][keymap] = keymap_opts
        else -- if not which-key mapping, set it
          vim.keymap.set(mode, keymap, cmd, keymap_opts)
        end
      end
    end
  end
end

function M.event(ev)
  vim.schedule(function()
    vim.api.nvim_exec_autocmds('User', { pattern = ev })
  end)
end

--- Run a shell command and capture the output and if the command succeeded or failed
---@param cmd table the terminal command to execute
---@param show_error boolean of whether or not to show an unsuccessful command as an error to the user
---@return string? the result of a successfully executed command or nil
function M.cmd(cmd, show_error)
  if vim.fn.has 'win32' == 1 then cmd = { 'cmd.exe', '/C', cmd } end
  local result = vim.fn.system(cmd)
  local success = vim.api.nvim_get_vvar 'shell_error' == 0
  if not success and (show_error == nil or show_error) then
    vim.api.nvim_err_writeln('Error running command: ' .. cmd .. '\nError message:\n' .. result)
  end
  return success and result:gsub('[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]', '') or nil
end

--- A helper function to wrap a module function to require a plugin before running
---@param plugin string the plugin string to call `require("lazy").load` with
---@param module any the system module where the functions live (e.g. `vim.ui`)
---@param func_names table|string a string or a list like table of strings for functions to wrap in the given module (e.g. `{ "ui", "select }`)
function M.load_plugin_with_func(plugin, module, func_names)
  if type(func_names) == 'string' then func_names = { func_names } end
  for _, func in ipairs(func_names) do
    local old_func = module[func]
    module[func] = function(...)
      module[func] = old_func
      require('lazy').load { plugins = { plugin } }
      module[func](...)
    end
  end
end

--- Check if a plugin is defined in lazy. Useful with lazy loading when a plugin is not necessarily loaded yet
---@param plugin string The plugin to search for
---@return boolean available # Whether the plugin is available
function M.has(plugin)
  local lazy_config_avail, lazy_config = pcall(require, 'lazy.core.config')
  return lazy_config_avail and lazy_config.plugins[plugin] ~= nil
end

return M
