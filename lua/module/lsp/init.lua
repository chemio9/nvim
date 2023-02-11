local utils = require 'core.utils'
local nvim_capabilities = vim.lsp.protocol.make_client_capabilities()
nvim_capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
nvim_capabilities.textDocument.completion.completionItem.snippetSupport = true
nvim_capabilities.textDocument.completion.completionItem.preselectSupport = true
nvim_capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
nvim_capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
nvim_capabilities.textDocument.completion.completionItem.deprecatedSupport = true
nvim_capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
nvim_capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
nvim_capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { 'documentation', 'detail', 'additionalTextEdits' },
}

local setup_diagnostics = function()

  local DapBreakpoint = ""
  local DapBreakpointCondition = ""
  local DapBreakpointRejected = ""
  local DapLogPoint = "->"
  local DapStopped = ""
  local DiagnosticError = ""
  local DiagnosticHint = ""
  local DiagnosticInfo = ""
  local DiagnosticWarn = ""

  local signs = {
    { name = "DiagnosticSignError", text = DiagnosticError, texthl = "DiagnosticSignError" },
    { name = "DiagnosticSignWarn", text = DiagnosticWarn, texthl = "DiagnosticSignWarn" },
    { name = "DiagnosticSignHint", text = DiagnosticHint, texthl = "DiagnosticSignHint" },
    { name = "DiagnosticSignInfo", text = DiagnosticInfo, texthl = "DiagnosticSignInfo" },
    { name = "DapStopped", text = DapStopped, texthl = "DiagnosticWarn" },
    { name = "DapBreakpoint", text = DapBreakpoint, texthl = "DiagnosticInfo" },
    { name = "DapBreakpointRejected", text =DapBreakpointRejected, texthl = "DiagnosticError" },
    { name = "DapBreakpointCondition", text = DapBreakpointCondition, texthl = "DiagnosticInfo" },
    { name = "DapLogPoint", text = DapLogPoint, texthl = "DiagnosticInfo" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, sign)
  end

  local diagnostics = {
    virtual_text = true,
    signs = { active = signs },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focused = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  }

  vim.diagnostic.config(diagnostics)
end

local on_attach = function(client, bufnr)
  local capabilities = client.server_capabilities
  local lmap = { i = {}, n = {}, v = {}, t = {}, [''] = {} }
  -- Diagnsotics
  lmap.n['<leader>e'] = { name = 'diagnostic' }
  lmap.n['<leader>ef'] = { vim.diagnostic.open_float, desc = 'diagnostics in float' }
  lmap.n['<leader>eq'] = { vim.diagnostic.setloclist, desc = 'diagnostics in location list' }
  -- Diagnsotic jump can use `<c-o>` to jump back
  lmap.n['[e'] = { '<cmd>Lspsaga diagnostic_jump_prev<CR>', desc = 'previous diagnostic' }
  lmap.n[']e'] = { '<cmd>Lspsaga diagnostic_jump_next<CR>', desc = 'next diagnostic' }
  -- Only jump to error
  lmap.n['[E'] = { function() require 'lspsaga.diagnostic'.goto_prev { severity = vim.diagnostic.severity.ERROR } end,
    desc = 'previous error', }
  lmap.n[']E'] = { function() require 'lspsaga.diagnostic'.goto_next { severity = vim.diagnostic.severity.ERROR } end,
    desc = 'next error', }

  lmap.n['<leader>wa'] = { vim.lsp.buf.add_workspace_folder, desc = 'add workspace folder' }
  lmap.n['<leader>wr'] = { vim.lsp.buf.remove_workspace_folder, desc = 'remove workspace folder' }
  lmap.n['<leader>wl'] = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    desc = 'list workspace folders', }

  lmap.n['<leader>c'] = { name = 'Code' }
  if capabilities.codeActionProvider then
    -- Code action
    lmap.n['<leader>ca'] = { '<cmd>Lspsaga code_action<CR>', desc = 'run code action' }
    lmap.v['<leader>ca'] = lmap.n['<leader>ca']
  end

  -- if capabilities.codeLensProvider then
  --   add_buffer_autocmd('lsp_codelens_refresh', bufnr, {
  --     events = { 'InsertLeave', 'BufEnter' },
  --     callback = function()
  --       if vim.g.codelens_enabled then vim.lsp.codelens.refresh() end
  --     end,
  --   })
  --   vim.lsp.codelens.refresh()
  --   lmap.n['<leader>ll'] = { function() vim.lsp.codelens.refresh() end, desc = 'LSP CodeLens refresh' }
  --   lmap.n['<leader>lL'] = { function() vim.lsp.codelens.run() end, desc = 'LSP CodeLens run' }
  -- end

  if capabilities.declarationProvider then
    lmap.n['gD'] = { function() vim.lsp.buf.declaration() end, desc = 'Declaration of current symbol' }
  end

  if capabilities.definitionProvider then
    lmap.n['gd'] = { function() vim.lsp.buf.definition() end, desc = 'Show the definition of current symbol' }
    lmap.n['gp'] = { '<cmd>Lspsaga peek_definition<CR>', desc = 'peek definition' }
  end

  if capabilities.documentFormattingProvider then
    lmap.n['<leader>cf'] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      desc = 'format',
    }
    lmap.v['<leader>cf'] = lmap.n['<leader>cf']
  end

  -- if capabilities.documentHighlightProvider then
  --   add_buffer_autocmd('lsp_document_highlight', bufnr, {
  --     { events = { 'CursorHold', 'CursorHoldI' }, callback = function() vim.lsp.buf.document_highlight() end },
  --     { events = 'CursorMoved', callback = function() vim.lsp.buf.clear_references() end },
  --   })
  -- end

  if capabilities.hoverProvider then
    lmap.n['K'] = { function() vim.lsp.buf.hover() end, desc = 'Hover symbol details' }
  end

  if capabilities.implementationProvider then
    lmap.n['gi'] = { function() vim.lsp.buf.implementation() end, desc = 'Implementation of current symbol' }
  end

  if capabilities.referencesProvider then
    lmap.n['gr'] = { '<cmd>Lspsaga lsp_finder<CR>', desc = 'find references' }
  end

  if capabilities.renameProvider then
    lmap.n['<leader>cr'] = { '<cmd>Lspsaga rename<CR>', desc = 'rename symbols' }
  end

  if capabilities.signatureHelpProvider then
    lmap.n['<leader>ch'] = { function() vim.lsp.buf.signature_help() end, desc = 'Signature help' }
  end

  if capabilities.typeDefinitionProvider then
    lmap.n['gt'] = { function() vim.lsp.buf.type_definition() end, desc = 'Definition of current type' }
  end

  if capabilities.workspaceSymbolProvider then
    lmap.n['<leader>cG'] = { function() vim.lsp.buf.workspace_symbol() end, desc = 'Search workspace symbols' }
  end

  if capabilities.documentSymbolProvider then
    lmap.n['<leader>co'] = { '<cmd>Lspsaga outline<CR>', desc = 'symbols outline' }
  end
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  utils.setup_mappings(lmap, bufopts)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

return {
  on_attach = on_attach,
  capabilities = nvim_capabilities,
  setup_diagnostics = setup_diagnostics,
}
