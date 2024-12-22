---@type LazySpec[]
return {
  -- lazy.nvim
  {
    'lervag/vimtex',
    lazy = false,
    init = function()
      -- Use init for configuration, don't use the more common "config".
      vim.g.tex_flavor = 'latex'
      vim.g.vimtex_compiler_latexmk_engines = { ['_'] = '-xelatex' }
      vim.g.vimtex_compiler_latexrun_engines = { ['_'] = 'xelatex' }
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_imaps_enabled = 0                      -- disable vimtex mappings (they don't work with treesitter anyway)
      vim.g.vimtex_imaps_leader = ';'
      vim.g.vimtex_mappings_disable = { ['n'] = { 'K' } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_matchparen_enabled = 0                 -- prefer treesitter's matchparen
      vim.g.vimtex_syntax_conceal_disable = 1             -- also disable conceal completely
      vim.g.vimtex_syntax_enabled = 0                     -- prefer treesitter for faster syntax highlighting and math detection
      vim.g.vimtex_view_method = 'zathura'

      vim.g.vimtex_env_toggle_math_map = { ['\\('] = '\\[', ['\\['] = 'equation', ['equation'] = '\\(' }
      vim.g.vimtex_echo_verbose_input = 0
      vim.g.vimtex_env_change_autofill = 1
      -- vim.g.vimtex_ui_method = {
      --     confirm = 'legacy',
      --     input = 'legacy',
      --     select = 'nvim',
      -- }

      vim.g.vimtex_quickfix_mode = 0

      vim.g.vimtex_toc_config = {
        layer_status = { ['content'] = 1, ['label'] = 0, ['todo'] = 1, ['include'] = 0 },
        show_help = 0,
        todo_sorted = 0,
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'tex' },
        callback = function(e)
          vim.cmd [[set wrap spell spelloptions=camel spelllang=en,cjk conceallevel=0]]
        end,
      }
      )
    end,
  },

  -- Add latexindent and bibtex-tidy to conform.nvim
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = function(_, opts)
      local Util = require('conform.util')
      local opts_tex = {
        formatters_by_ft = {
          tex = { 'latexindent' },
          bib = { 'bibtex-tidy' },
        },
        -- stylua: ignore
        formatters = {
          latexindent = {
            cwd = Util.root_file({ '.latexmkrc', '.git' }),
            prepend_args = {
              '-c', './.aux', -- location of `indent.log`
              '-l', vim.fn.stdpath('config') .. '/latexindent/latexindent.yaml',
            },
          },
          ['bibtex-tidy'] = {
            prepend_args = {
              '--space=4', '--trailing-commas',
              -- '--sort',
              '--sort-fields=' .. table.concat({
                'author', 'title', 'shorttitle', 'subtitle',
                'journal', 'on', 'publisher', 'school', 'series',
                'volume', 'issue', 'number', 'pages', 'year', 'month', 'day',
                'doi', 'url', 'archiveprefix', 'primaryclass', 'eprint',
              }, ','),
              '--curly', '--remove-braces', '--enclosing-braces',
            },
          },
        },
      }
      return vim.tbl_deep_extend('force', opts, opts_tex)
    end,
  },

  {
    'L3MON4D3/LuaSnip',
    opts = {
      -- for luasnip-latex-snippets.nvim
      enable_autosnippets = true,
    },
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        ltex = {
          enabled = true,
          autostart = false, -- manually by ltex_extra keybinding
          settings = {
            ltex = {
              checkFrequency = 'save',
              latex = {
                commands = {
                  ['\\si{}'] = 'dummy',
                  ['\\SI{}'] = 'dummy',
                  ['\\SI{}{}'] = 'dummy',
                },
              },
            },
          },
        },
        texlab = {
          keys = {
            { 'gK',      '<plug>(vimtex-doc-package)' },
            { '<A-Tab>', '<plug>(vimtex-toc-open)' },
            { 'im',      '<plug>(vimtex-i$)',             mode = { 'x', 'o' } },
            { 'am',      '<plug>(vimtex-a$)',             mode = { 'x', 'o' } },
            { 'dsm',     '<plug>(vimtex-env-delete-math)' },
            { 'csm',     '<plug>(vimtex-env-change-math)' },
            { 'tsm',     '<plug>(vimtex-env-toggle-math)' },
            {
              '<leader>lf',
              [[mc<CMD>%s/,\s*label=current//e<CR>`c$?in{frame<CR>f]i, label=current<ESC>`c]],
              desc = 'Beamer: show only current slide/frame',
            },
          },
          inlay_hints_default = false,
          settings = {
            texlab = {
              forwardSearch = {
                -- https://github.com/latex-lsp/texlab/wiki/Previewing
                executable = 'zathura',
                args = { '--synctex-forward', '%l:1:%f', '%p' },
              },
              inlayHints = {
                labelDefinitions = true,
                labelReferences = true,
              },
            },
          },
        },
      },
    },
  },

  {
    'iurimateus/luasnip-latex-snippets.nvim',
    -- vimtex isn't required if using treesitter
    dependencies = { 'lervag/vimtex' },
    -- already lazy load by FileType
    lazy = false,
    config = function()
      require 'luasnip-latex-snippets'.setup({ use_treesitter = true })
    end,
  },

}
