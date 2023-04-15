require 'nvim-tree'.setup {
  disable_netrw = true,
  hijack_netrw = true,
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  renderer = {
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        git = false,
      },
    },
    special_files = {
      'Cargo.toml',
      'Makefile',
      'README.md',
      'readme.md',
      'PKGBUILD',
      'package.json',
      'CMakeLists.txt',
    },
  },
  system_open = {
    cmd = 'xdg-open',
  },
  diagnostics = {
    enable = true,
  },
  git = {
    enable = false,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  live_filter = {
    prefix = '[F]: ',
    always_show_folders = false,
  },
}
