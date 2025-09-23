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
