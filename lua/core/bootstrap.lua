local lazypath = vim.fn.stdpath 'config' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
  local oldcmdheight = vim.opt.cmdheight:get()
  vim.opt.cmdheight = 1
  vim.notify 'Please wait while plugins are installed...'
  vim.api.nvim_create_autocmd('User', {
    once = true,
    pattern = 'LazyInstall',
    callback = function()
      vim.cmd.bw()
      vim.opt.cmdheight = oldcmdheight
      vim.tbl_map(function(module) pcall(require, module) end,
                  { 'nvim-treesitter' })
    end,
  })
end
vim.opt.rtp:prepend(lazypath)
