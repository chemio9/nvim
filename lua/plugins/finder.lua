--- @type LazySpec[]
return {
  {
    'ibhagwan/fzf-lua',
    -- optional for icon support
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- calling `setup` is optional for customization
      require('fzf-lua').setup({})
    end,
    cmd = 'FzfLua',
    keys = {
      { '<leader>fg',       function() require('fzf-lua').live_grep() end,     desc = 'Live Grep (Rg)' },
      { '<leader><leader>', function() require('fzf-lua').resume() end,        desc = 'Resume Last' },
      { '<C-x><C-f>',       function() require('fzf-lua').complete_path() end, desc = 'Complete path',  mode = 'i' },
      { '<leader>fb',       function() require('fzf-lua').buffers() end,       desc = 'buffers' },
    },
  },
}
