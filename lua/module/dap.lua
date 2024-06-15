-- vim: fdm=marker:foldlevel=0
local dap = require 'dap'

local icons = require 'core.icons'
local signs = {
  { name = 'DapStopped',             text = icons.DapStopped,             texthl = 'DiagnosticWarn' },
  { name = 'DapBreakpoint',          text = icons.DapBreakpoint,          texthl = 'DiagnosticInfo' },
  { name = 'DapBreakpointRejected',  text = icons.DapBreakpointRejected,  texthl = 'DiagnosticError' },
  { name = 'DapBreakpointCondition', text = icons.DapBreakpointCondition, texthl = 'DiagnosticInfo' },
  { name = 'DapLogPoint',            text = icons.DapLogPoint,            texthl = 'DiagnosticInfo' },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, sign)
end

-- neovim lua {{{
dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 })
end

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
  },
}
-- }}}

-- lldb for rust c cpp {{{
dap.adapters.lldb = {
  type = 'executable',
  -- must be absolute path
  command = '/usr/bin/lldb-vscode',
  name = 'lldb',
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return coroutine.create(function(dap_run_co)
        local current = vim.fn.expand('%:p:h')
        -- if err~=nil then
        --   vim.notify("DAP ERROR:"..msg,vim.log.levels.ERROR)
        --   coroutine.resume(dap_run_co, dap.ABORT)
        -- end
        vim.ui.input({ prompt = 'file>', completion = 'file', default = current }, function(choice)
          coroutine.resume(dap_run_co, choice)
        end)
      end)
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
-- }}}
