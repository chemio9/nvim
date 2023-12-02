require('nvim-autopairs').setup {
  enable_check_bracket_line = true,
  check_ts = true,
  ignored_next_char = '[%w%.]', -- will ignore alphanumeric and `.` symbol
  ts_config = { java = false },
  fast_wrap = {
    map = '<M-e>',
    chars = { '{', '[', '(', '"', "'" },
    end_key = '$',
    offset = 0,
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    check_comma = true,
    highlight = 'Search',
    highlight_grey = 'Comment',
  },
}

local cmp_status_ok, cmp = pcall(require, 'cmp')
if cmp_status_ok then
  cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done { tex = false })
end
