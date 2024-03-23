local M = {
  which_key_queue = nil,
  opts = {},
}

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

---@class KeyOpt
---@field expr boolean?
---@field silent boolean?
---@field noremap boolean?
---@field desc string? description
---@field buffer number? buffer number
---
---@class KeyRecord: KeyOpt
---@field [1] string|function? key to be mapped

---map keys
--- map('n', '<C-N>', { '<cmd>bnext<CR>', desc = 'Next buf' })
---@param mode 'v'|'n'|'i'|'t'|'c'|table
---@param key string
---@param map KeyRecord
function M.map(mode, key, map)
  if map[1] then
    local opts = vim.deepcopy(map)
    opts[1] = nil
    vim.keymap.set(mode, key, map[1], vim.tbl_deep_extend('force', M.opts, opts))
  else
    M.which_key_queue = M.which_key_queue or {}
    M.which_key_queue[mode] = M.which_key_queue[mode] or {}
    if type(mode) == 'table' then
      for _, v in ipairs(mode) do
        M.which_key_queue[v][key] = map
      end
    else
      M.which_key_queue[mode][key] = map
    end
  end
end

---set opts for the rest operations
---@param opt KeyOpt
function M.map_opt(opt)
  M.opts = opt
end

function M.event(ev)
  vim.schedule(function()
    vim.api.nvim_exec_autocmds('User', { pattern = ev })
  end)
end

--- A helper function to wrap a module function to require a plugin before running
---@param plugin string the plugin string to call `require("lazy").load` with
---@param module any the system module where the functions live (e.g. `vim.ui`)
---@param func_names table|string a string or a list like table of strings for functions to wrap in the given module (e.g. `{ "ui", "select }`)
function M.load_plugin_with_func(plugin, module, func_names)
  if type(func_names) == 'string' then func_names = { func_names } end
  for _, func in ipairs(func_names) do
    module[func] = function(...)
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
