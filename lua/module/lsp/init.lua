local utils = require 'core.utils'
local cap = vim.lsp.protocol.make_client_capabilities()
cap.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
cap.textDocument.completion.completionItem.snippetSupport = true
cap.textDocument.completion.completionItem.preselectSupport = true
cap.textDocument.completion.completionItem.insertReplaceSupport = true
cap.textDocument.completion.completionItem.labelDetailsSupport = true
cap.textDocument.completion.completionItem.deprecatedSupport = true
cap.textDocument.completion.completionItem.commitCharactersSupport = true
cap.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
cap.textDocument.completion.completionItem.resolveSupport = {
  properties = { 'documentation', 'detail', 'additionalTextEdits' },
}

local setup_diagnostics = function()
  local icons = require 'core.icons'
  local signs = {
    { name = 'DiagnosticSignError',    text = icons.DiagnosticError,        texthl = 'DiagnosticSignError' },
    { name = 'DiagnosticSignWarn',     text = icons.DiagnosticWarn,         texthl = 'DiagnosticSignWarn' },
    { name = 'DiagnosticSignHint',     text = icons.DiagnosticHint,         texthl = 'DiagnosticSignHint' },
    { name = 'DiagnosticSignInfo',     text = icons.DiagnosticInfo,         texthl = 'DiagnosticSignInfo' },
    { name = 'DapStopped',             text = icons.DapStopped,             texthl = 'DiagnosticWarn' },
    { name = 'DapBreakpoint',          text = icons.DapBreakpoint,          texthl = 'DiagnosticInfo' },
    { name = 'DapBreakpointRejected',  text = icons.DapBreakpointRejected,  texthl = 'DiagnosticError' },
    { name = 'DapBreakpointCondition', text = icons.DapBreakpointCondition, texthl = 'DiagnosticInfo' },
    { name = 'DapLogPoint',            text = icons.DapLogPoint,            texthl = 'DiagnosticInfo' },
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
  ---@diagnostic disable-next-line: redefined-local
  local function add_buffer_autocmd(augroup, bufnr, autocmds)
    if not vim.tbl_islist(autocmds) then autocmds = { autocmds } end
    local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })
    if not cmds_found or vim.tbl_isempty(cmds) then
      vim.api.nvim_create_augroup(augroup, { clear = false })
      for _, autocmd in ipairs(autocmds) do
        local events = autocmd.events
        autocmd.events = nil
        autocmd.group = augroup
        autocmd.buffer = bufnr
        vim.api.nvim_create_autocmd(events, autocmd)
      end
    end
  end

  local capabilities = client.server_capabilities
  local lmap = { i = {}, n = {}, v = {}, t = {},[''] = {} }
  -- Diagnsotics
  lmap.n['<leader>e'] = { name = 'diagnostic' }
  lmap.n['<leader>ef'] = { vim.diagnostic.open_float, desc = 'diagnostics in float' }
  lmap.n['<leader>eq'] = { vim.diagnostic.setloclist, desc = 'diagnostics in location list' }
  -- Diagnsotic jump can use `<c-o>` to jump back
  lmap.n['[e'] = { '<cmd>Lspsaga diagnostic_jump_prev<CR>', desc = 'previous diagnostic' }
  lmap.n[']e'] = { '<cmd>Lspsaga diagnostic_jump_next<CR>', desc = 'next diagnostic' }
  -- Only jump to error
  lmap.n['[E'] = {
    function() require 'lspsaga.diagnostic'.goto_prev { severity = vim.diagnostic.severity.ERROR } end,
    desc = 'previous error',
  }
  lmap.n[']E'] = {
    function() require 'lspsaga.diagnostic'.goto_next { severity = vim.diagnostic.severity.ERROR } end,
    desc = 'next error',
  }

  lmap.n['<leader>wa'] = { vim.lsp.buf.add_workspace_folder, desc = 'add workspace folder' }
  lmap.n['<leader>wr'] = { vim.lsp.buf.remove_workspace_folder, desc = 'remove workspace folder' }
  lmap.n['<leader>wl'] = {
    function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    desc = 'list workspace folders',
  }

  lmap.n['<leader>c'] = { name = 'Code' }
  if capabilities.codeActionProvider then
    -- Code action
    lmap.n['<leader>ca'] = { '<cmd>Lspsaga code_action<CR>', desc = 'run code action' }
    lmap.v['<leader>ca'] = lmap.n['<leader>ca']
  end

  if capabilities.codeLensProvider then
    add_buffer_autocmd('lsp_codelens_refresh', bufnr, {
      events = { 'InsertLeave', 'BufEnter' },
      callback = function()
        if vim.g.codelens_enabled then vim.lsp.codelens.refresh() end
      end,
    })
    vim.lsp.codelens.refresh()
    lmap.n['<leader>ll'] = { function() vim.lsp.codelens.refresh() end, desc = 'LSP CodeLens refresh' }
    lmap.n['<leader>lL'] = { function() vim.lsp.codelens.run() end, desc = 'LSP CodeLens run' }
  end

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

  if capabilities.documentHighlightProvider then
    add_buffer_autocmd('lsp_document_highlight', bufnr, {
      { events = { 'CursorHold', 'CursorHoldI' }, callback = function() vim.lsp.buf.document_highlight() end },
      { events = 'CursorMoved',                   callback = function() vim.lsp.buf.clear_references() end },
    })
  end

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
    ---@diagnostic disable-next-line: missing-parameter
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
  capabilities = cap,
  setup_diagnostics = setup_diagnostics,
}
