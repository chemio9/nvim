require 'dressing'.setup {
  input = {
    default_prompt = '➤ ',
    win_options = { winhighlight = 'normal:normal,normalnc:normal' },
  },
  select = {
    backend = { 'telescope', 'builtin' },
    builtin = { win_options = { winhighlight = 'normal:normal,normalnc:normal' } },
  },
}
