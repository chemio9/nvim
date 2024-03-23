---@type LazySpec[]
return {
  -- lazy.nvim
  {
    'lervag/vimtex',
    lazy = false,
    init = function()
      -- Use init for configuration, don't use the more common "config".
      vim.g.tex_flavor = 'latex'
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_compiler_latexmk_engines = { ['_'] = '-xelatex' }
      vim.g.vimtex_compiler_latexrun_engines = { ['_'] = 'xelatex' }
      vim.g.vimtex_fold_enabled = 1

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'tex' },
        callback = function(e)
          vim.wo[0].wrap = true
        end,
      }
      )
    end,
  },

  {
    'iurimateus/luasnip-latex-snippets.nvim',
    -- vimtex isn't required if using treesitter
    dependencies = { 'lervag/vimtex' },
    -- already lazy load by FileType
    lazy = false,
    config = function()
      require 'luasnip-latex-snippets'.setup()
      -- or setup({ use_treesitter = true })
    end,
  },

}
