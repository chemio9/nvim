---@diagnostic disable: inject-field
local utils = require 'core.utils'
local map = utils.map

--- make client capabilities for lsp
---@return lsp.ClientCapabilities
local function make_capabilities()
  local cap = vim.lsp.protocol.make_client_capabilities()
  local cItem = cap.textDocument.completion.completionItem
  cItem.documentationFormat = { 'markdown', 'plaintext' }
  cItem.snippetSupport = true
  cItem.preselectSupport = true
  cItem.insertReplaceSupport = true
  cItem.labelDetailsSupport = true
  cItem.deprecatedSupport = true
  cItem.commitCharactersSupport = true
  cItem.tagSupport = { valueSet = { 1 } }
  cItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' },
  }
  return cap
end

---setup diagnostics for vim
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
    virtual_text = false,
    signs = { active = signs },
    update_in_insert = false,
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

---attach function for lsp
---TODO: use LSPAttach and LSPDetach
---@param client lsp.Client
---@param bufnr number
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

  utils.map_opt({ noremap = true, silent = true, buffer = bufnr })

  map('n', '<leader>e', { desc = ' LSP' })
  map('n', '<leader>eD', { function() require('telescope.builtin').diagnostics() end, desc = 'Search diagnostics' })
  map('n', '<leader>es', { function() require('telescope.builtin').lsp_document_symbols() end, desc = 'Search symbols' })

  -- Diagnsotics
  map('n', '<leader>ed', {
    function()
      require('trouble').open 'workspace_diagnostics'
    end,
    desc = 'Workspace Diagnostics',
  })

  -- Diagnsotic jump can use `<c-o>` to jump back
  map('n', '[e', { '<cmd>LspUI diagnostic prev<CR>', desc = 'previous diagnostic' })
  map('n', ']e', { '<cmd>LspUI diagnostic next<CR>', desc = 'next diagnostic' })

  map('n', '<leader>ew', { desc = 'Workspaces' })
  map('n', '<leader>ewa', { vim.lsp.buf.add_workspace_folder, desc = 'add workspace folder' })
  map('n', '<leader>ewr', { vim.lsp.buf.remove_workspace_folder, desc = 'remove workspace folder' })
  map('n', '<leader>ewl',
    { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc = 'list workspace folders' })

  map('n', '<leader>c', { desc = 'Code' })
  -- Code action
  map({ 'n', 'v' }, '<leader>ca', { '<cmd>LspUI code_action<CR>', desc = 'run code action' })

  map('n', 'gD', { '<cmd>LspUI declaration<CR>', desc = 'Declaration of current symbol' })

  map('n', 'gd', { '<cmd>LspUI definition<CR>', desc = 'Show the definition of current symbol' })
  -- TODO: glances.nvim or goto-preview
  -- map('n','gp',{ '<cmd>LspUI peek_definition<CR>', desc = 'peek definition' })
  -- if capabilities.documentSymbolProvider then
  --   -- map('n','<leader>co',{ '<cmd>Lspsaga outline<CR>', desc = 'symbols outline' })
  -- end

  map({ 'n', 'v' }, '<leader>cf',
    { function() require('conform').format { async = true, lsp_fallback = true } end, desc = 'format' })

  map('n', '<leader>ch', { '<cmd>LspUI hover<CR>', desc = 'Hover symbol details' })
  map('n', 'gi', { '<cmd>LspUI implementation<CR>', desc = 'Implementation of current symbol' })
  map('n', 'gr', { '<cmd>LspUI reference<CR>', desc = 'find references' })
  map('n', '<leader>cr', { '<cmd>LspUI rename<CR>', desc = 'rename symbols' })
  map('n', '<leader>cs', { function() vim.lsp.buf.signature_help() end, desc = 'Signature help' })
  map('n', 'gt', { '<cmd>LspUI type_definition<CR>', desc = 'Definition of current type' })

  if capabilities.workspaceSymbolProvider then
    --@diagnostic disable-next-line: missing-parameter
    map('n', '<leader>cG',
      {
        function()
          vim.ui.input({ prompt = 'Symbol Query: ' },
            function(query) if query then require('telescope.builtin').lsp_workspace_symbols { query = query } end end)
        end,
        desc =
        'Search workspace symbols',
      })
  end

  if capabilities.semanticTokensProvider then vim.lsp.semantic_tokens.start(bufnr, client.id) end

  if capabilities.codeLensProvider then
    if not require('core.utils').has 'lsp-lens.nvim' then
      add_buffer_autocmd('lsp_codelens_refresh', bufnr, {
        events = { 'InsertLeave', 'BufEnter' },
        callback = function()
          if vim.g.codelens_enabled then vim.lsp.codelens.refresh() end
        end,
      })
      vim.lsp.codelens.refresh()
      map('n', '<leader>el', { function() vim.lsp.codelens.refresh() end, desc = 'LSP CodeLens refresh' })
      map('n', '<leader>eL', { function() vim.lsp.codelens.run() end, desc = 'LSP CodeLens run' })
    end
  end

  if false and capabilities.documentHighlightProvider then
    add_buffer_autocmd('lsp_document_highlight', bufnr, {
      {
        events = { 'CursorHold', 'CursorHoldI' },
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      },
      {
        events = 'CursorMoved',
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      },
    })
  end

  --if capabilities.inlayHintsProvider then
  -- TODO
  --end

  utils.which_key_register()
end

return {
  on_attach = on_attach,
  capabilities = make_capabilities(),
  setup_diagnostics = setup_diagnostics,
}
