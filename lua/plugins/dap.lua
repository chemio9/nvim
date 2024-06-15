--- @type LazySpec[]
return {
  {
    'mfussenegger/nvim-dap',
    enabled = vim.fn.has 'win32' == 0,
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        config = function()
          local dap, dapui = require 'dap', require 'dapui'
          dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close()
          end
          dapui.setup { floating = { border = 'rounded' } }
        end,
        dependencies = {
          'nvim-neotest/nvim-nio',
        },
      },
      'stevearc/overseer.nvim',
    },
    config = function()
      require 'module.dap'
      require('overseer').enable_dap(true)
      require('dap.ext.vscode').json_decode = require('overseer.json').decode
    end,
    keys = {
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle Breakpoint (F9)',
      },
      {
        '<leader>dB',
        function()
          require('dap').clear_breakpoints()
        end,
        desc = 'Clear Breakpoints',
      },
      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = 'Start/Continue (F5)',
      },
      {
        '<leader>di',
        function()
          require('dap').step_into()
        end,
        desc = 'Step Into (F11)',
      },
      {
        '<leader>do',
        function()
          require('dap').step_over()
        end,
        desc = 'Step Over (F10)',
      },
      {
        '<leader>dO',
        function()
          require('dap').step_out()
        end,
        desc = 'Step Out (S-F11)',
      },
      {
        '<leader>dq',
        function()
          require('dap').close()
        end,
        desc = 'Close Session',
      },
      {
        '<leader>dQ',
        function()
          require('dap').terminate()
        end,
        desc = 'Terminate Session (S-F5)',
      },
      {
        '<leader>dp',
        function()
          require('dap').pause()
        end,
        desc = 'Pause (F6)',
      },
      {
        '<leader>dr',
        function()
          require('dap').restart_frame()
        end,
        desc = 'Restart (C-F5)',
      },
      {
        '<leader>dR',
        function()
          require('dap').repl.toggle()
        end,
        desc = 'Toggle REPL',
      },
      {
        '<leader>du',
        function()
          require('dapui').toggle()
        end,
        desc = 'Toggle Debugger UI',
      },
      {
        '<leader>dh',
        function()
          require('dap.ui.widgets').hover()
        end,
        desc = 'Debugger Hover',
      },
    },
  },

  {
    'jbyuki/one-small-step-for-vimkind',
    event = 'BufEnter',
    config = function()
      local map = require('core.utils').map
      map('n', '<F5>', { function() require 'osv'.launch({ port = 8086 }) end })
      map('n', '<F6>', { function() require 'osv'.run_this() end })
    end,
  },

  {
    'stevearc/overseer.nvim',
    opts = function()
      return {
        strategy = {
          'toggleterm',
          direction = 'tab',
          quit_on_exit = 'never', -- or 'always', 'success'
          open_on_start = true,
        },
        dap = false, -- disable automatic loading dap, as we load it manually in dap.config
        form = {
          border = 'rounded',
        },
        confirm = {
          border = 'rounded',
        },
        task_win = {
          border = 'rounded',
        },
        component_aliases = {
          default = {
            { 'display_duration', detail_level = 2 },
            'on_output_summarize',
            'on_exit_set_status',
            'on_complete_notify',
            'on_complete_dispose',
            'unique',
          },
        },
      }
    end,
    config = function(_, opts)
      local overseer = require 'overseer'

      overseer.setup(opts)

      local templates = {
        {
          name = 'C++ build single file',
          builder = function()
            return {
              cmd = { 'c++' },
              args = {
                '-g',
                vim.fn.expand '%:p',     -- full path
                '-o',
                vim.fn.expand '%:p:t:r', -- tail path, removed one extension
              },
            }
          end,
          condition = {
            filetype = { 'cpp' },
          },
        },
        {
          name = 'Xmake build project',
          builder = function()
            return {
              cmd = { 'xmake' },
              args = {
                'build',
              },
            }
          end,
          condition = {
            filetype = { 'cpp', 'c' },
          },
        },
      }
      for _, template in ipairs(templates) do
        overseer.register_template(template)
      end
    end,
    keys = {
      { '<leader>rr', '<cmd>OverseerRun<CR>',        desc = 'Run' },
      { '<leader>rl', '<cmd>OverseerToggle<CR>',     desc = 'List' },
      { '<leader>rn', '<cmd>OverseerBuild<CR>',      desc = 'New' },
      { '<leader>ra', '<cmd>OverseerTaskAction<CR>', desc = 'Action' },
      { '<leader>ri', '<cmd>OverseerInfo<CR>',       desc = 'Info' },
      { '<leader>rc', '<cmd>OverseerClearCache<CR>', desc = 'Clear cache' },
    },
    cmd = {
      'OverseerOpen',
      'OverseerClose',
      'OverseerToggle',
      'OverseerSaveBundle',
      'OverseerLoadBundle',
      'OverseerDeleteBundle',
      'OverseerRunCmd',
      'OverseerRun',
      'OverseerInfo',
      'OverseerBuild',
      'OverseerQuickAction',
      'OverseerTaskAction',
      'OverseerClearCache',
    },
  },

}
