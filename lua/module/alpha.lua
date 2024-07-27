local dashboard = require 'alpha.themes.dashboard'
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local if_nil = vim.F.if_nil

autocmd('User', {
  group = augroup('profile', { clear = true }),
  pattern = 'LazyVimStarted',
  callback = function()
    local stats = require('lazy').stats()
    local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
    dashboard.section.footer.val = {
      'Neovim Loaded ' ..
      stats.loaded .. '/' .. stats.count ..
      ' plugins   in ' .. ms .. 'ms',
    }
    pcall(vim.cmd.AlphaRedraw)
  end,
})

local logo = [[
 ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓
 ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒ ██▒ ██▒▀█▀ ██▒
▓██  ▀█ ██ ▒███   ▒██░  ██▒ ▓██  █▒░ ██▒ ██    ▓██░
▓██▒  ▐▌██ ▒██  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██
▒██░   ▓██░░█████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒
░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░
░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░   ░  ░
   ░   ░      ░     ░ ░ ▒       ░░   ▒ ░░
                      ░ ░        ░   ░
]]

dashboard.section.header.val = vim.split(logo, '\n')

local LEADER = 'LDR'
local function button(sc, txt, keybind, keybind_opts)
  local sc_ = sc:gsub(LEADER, '<leader>'):gsub('%s', '')

  local opts = {
    position = 'center',
    text = txt,
    shortcut = sc,
    cursor = 5,
    width = 36,
    align_shortcut = 'right',
    hl = 'DashboardCenter',
    hl_shortcut = 'DashboardShortcut',
  }
  if keybind then
    keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
    opts.keymap = { 'n', sc_, keybind, keybind_opts }
  end

  local function on_press()
    local key = vim.api.nvim_replace_termcodes(sc_ .. '<Ignore>', true, false, true)
    vim.api.nvim_feedkeys(key, 't', false)
  end

  return {
    type = 'button',
    val = txt,
    on_press = on_press,
    opts = opts,
  }
end
dashboard.section.buttons.val = {
  button('e', '  New File  ', '<cmd>ene <CR>'),
  button('LDR f f', '  File Finder '),
  button('LDR f b', '󱂬  Buffers'),
  button('LDR f g', '󰈭  Find Word  '),
  button(';', '  Bookmarks  '),
  -- button('LDR S l', '  Last Session  '),
}

dashboard.config.layout[1].val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) }
dashboard.config.layout[3].val = 5
dashboard.config.opts.noautocmd = true
dashboard.section.footer.opts.hl = 'DashboardFooter'
require('alpha').setup(dashboard.config)
