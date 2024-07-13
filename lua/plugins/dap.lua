return {
  'mfussenegger/nvim-dap',
  enabled = vim.fn.has 'win32' == 0,
  dependencies = {
    {
      'rcarriga/nvim-dap-ui',
      config = function()
        local dap, dapui = require 'dap', require 'dapui'
        dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
        dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
        dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
        dapui.setup { floating = { border = 'rounded' } }
      end,
    },
  },
  config = function()
    require 'module.dap'
  end,
}
