local config = require 'alpha.themes.dashboard'
config.section.footer.val = { ' ', ' ', ' ',
  'Loaded ' .. require 'lazy'.stats().count .. ' plugins ', }
require 'alpha'.setup(config.config)
