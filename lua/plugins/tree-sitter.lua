---@type LazySpec[]
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    config = function()
      require 'module.tree-sitter'
      local disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end
      local utils = require 'core.utils'
      local autocmd, augroup = utils.autocmd, utils.augroup

      autocmd('FileType', {
        group = augroup('treesitter.setup'),
        callback = function(args)
          local buf = args.buf
          local filetype = args.match

          -- need some mechanism to avoid running on buffers that do not
          -- correspond to a language (like oil.nvim buffers), this implementation
          -- checks if a parser exists for the current language
          local language = vim.treesitter.language.get_lang(filetype) or filetype
          local loadable, error = vim.treesitter.language.add(language)
          if not loadable then
            return
          end

          if not disable(language, buf) then
            vim.treesitter.start(buf, language)
          end
        end,
      })
    end,
  },

  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = true,
  },
}
