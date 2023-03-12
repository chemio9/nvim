require 'dressing'.setup {
  input = {
    default_prompt = '➤ ',
    win_options = { winhighlight = 'normal:normal,normalnc:normal' },
  },
  select = {
    backend = { 'fzf_lua', 'builtin' },
    builtin = { win_options = { winhighlight = 'normal:normal,normalnc:normal' } },
  },
}
