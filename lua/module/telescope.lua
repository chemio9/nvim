local actions = require 'telescope.actions'
local icon = require 'core.icons'
local telescope = require 'telescope'
local opts = {
  defaults = {
    prompt_prefix = string.format('%s ', icon.Search),
    selection_caret = string.format('%s ', icon.Selected),
    path_display = { 'truncate' },
    sorting_strategy = 'ascending',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },

    mappings = {
      i = {
        ['<C-n>'] = actions.cycle_history_next,
        ['<C-p>'] = actions.cycle_history_prev,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
      n = { ['q'] = actions.close },
    },
  },
}
telescope.setup(opts)

local utils = require 'core.utils'
local conditional_func = utils.conditional_func
conditional_func(telescope.load_extension, pcall(require, 'notify'), 'notify')
conditional_func(telescope.load_extension, pcall(require, 'aerial'), 'aerial')
conditional_func(telescope.load_extension, utils.has 'telescope-fzf-native.nvim', 'fzf')
