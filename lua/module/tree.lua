require 'nvim-tree'.setup {
  disable_netrw = true,
  hijack_netrw = true,
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
  modified = {
    enable = true,
  },
  live_filter = {
    prefix = '[FILTER]: ',
    always_show_folders = false,
  },
}
