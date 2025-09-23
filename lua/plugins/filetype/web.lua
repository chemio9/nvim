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
      ---@module "lspconfig"
      ---@type {[string]: lspconfig.Config|{}|fun(): lspconfig.Config}
      servers = {
        -- ts_ls = {},
        vtsls = function()
          local InstallLocation = require 'mason-core.installer.InstallLocation'
          local vue_install_path = InstallLocation.global():package('vue-language-server')
          return {
            filetypes = {
              'typescript',
              'typescriptreact',
              'typescript.tsx',
              'javascript',
              'javascriptreact',
              'javascript.jsx',
              'vue',
            },
            -- on_new_config = function(new_config, new_root_dir)
            --   local lib_path = vim.fs.find('node_modules/typescript/lib', { path = new_root_dir, upward = true })[1]
            --   if lib_path then
            --     new_config.init_options.typescript.tsdk = lib_path
            --   end
            -- end,

            settings = {
              vtsls = {
                autoUseWorkspaceTsdk = true,
                tsserver = {
                  globalPlugins = {
                    {
                      name = '@vue/typescript-plugin',
                      location = vim.fs.joinpath(
                        vue_install_path,
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
        mdx_analyzer = {},
        vue_ls = {},
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
            'mdx',
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
