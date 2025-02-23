local customizations = {
  { rule = 'style/*',   severity = 'off', fixable = true },
  { rule = 'format/*',  severity = 'off', fixable = true },
  { rule = '*-indent',  severity = 'off', fixable = true },
  { rule = '*-spacing', severity = 'off', fixable = true },
  { rule = '*-spaces',  severity = 'off', fixable = true },
  { rule = '*-order',   severity = 'off', fixable = true },
  { rule = '*-dangle',  severity = 'off', fixable = true },
  { rule = '*-newline', severity = 'off', fixable = true },
  { rule = '*quotes',   severity = 'off', fixable = true },
  { rule = '*semi',     severity = 'off', fixable = true },
}

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'dmmulroy/ts-error-translator.nvim',
        config = true,
      },
    },
    opts = {
      servers = {

        -- ts_ls = {},
        vtsls = function()
          return {
            filetypes = { 'typescript', 'typescriptreact', 'typescript.tsx', 'javascript', 'javascriptreact', 'javascript.jsx', 'vue' },
            settings = {
              vtsls = {
                tsserver = {
                  globalPlugins = {
                    {
                      name = '@vue/typescript-plugin',
                      location = vim.fs.joinpath(
                        require('mason-registry').get_package('vue-language-server'):get_install_path(),
                        '/node_modules/@vue/language-server'
                      ),
                      languages = { 'vue' },
                      configNamespace = 'typescript',
                      enableForWorkspaceTypescriptVersions = true,
                    },
                  },
                },
              },
            },
          }
        end,
        volar = {},
        emmet_ls = {},
        unocss = {},
        eslint = {
          filetypes = {
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
            'vue',
            'html',
            'markdown',
            'json',
            'jsonc',
            'yaml',
            'toml',
            'xml',
            'gql',
            'graphql',
            'astro',
            'svelte',
            'css',
            'less',
            'scss',
            'pcss',
            'postcss',
          },
          settings = {
            -- Silent the stylistic rules in you IDE, but still auto fix them
            rulesCustomizations = customizations,
          },
        },
      },
    },
  },
}
