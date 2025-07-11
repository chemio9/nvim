local ensure_installed = {
  'bash',
  'c',
  'comment',
  'cpp',
  'diff',
  'embedded_template',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'http',
  'ini',
  'javascript',
  'json',
  'json5',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'regex',
  'ron',
  'ssh_config',
  'toml',
  'vim',
  'vimdoc',
  'yaml',
  'yaml',
  'yuck',
  'zig',
}

local disable = function(lang, buf)
  local max_filesize = 100 * 1024 -- 100 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
  if ok and stats and stats.size > max_filesize then
    return true
  end
end

require('nvim-treesitter').install(ensure_installed)

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter.setup', {}),
  callback = function(args)
    local buf = args.buf
    local filetype = args.match

    -- need some mechanism to avoid running on buffers that do not
    -- correspond to a language (like oil.nvim buffers), this implementation
    -- checks if a parser exists for the current language
    local language = vim.treesitter.language.get_lang(filetype) or filetype
    if not vim.treesitter.language.add(language) then
      return
    end

    if not disable(language, buf) then
      vim.treesitter.start(buf, language)
    end
  end,
})
