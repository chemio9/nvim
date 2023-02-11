---@param plugin string
---@param sync? boolean
local function loadPlugin(plugin, sync)
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
local function setup_mappings(map_table, base)
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

return {
  loadPlugin = loadPlugin,
  setup_mappings = setup_mappings,
}
