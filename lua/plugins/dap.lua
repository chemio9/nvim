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
    },
    config = function()
      require 'module.dap'
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
    event = "BufEnter",
    config = function()
      local map = require('core.utils').map
      map('n', '<F5>', { function() require 'osv'.launch({ port = 8086 }) end })
      map('n', '<F6>', { function() require 'osv'.run_this() end })
    end,
  },
}
