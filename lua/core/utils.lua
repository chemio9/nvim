---@param plugin string
---@param sync? boolean
local function loadPlugin(plugin, sync)
  if sync == nil then
    sync = false
  end
  -- force = true ==> sync load
  require 'lazy.core.loader'.load(plugin, { cmd = 'Lazy load' }, { force = sync })
end

return {
  loadPlugin = loadPlugin,
}
