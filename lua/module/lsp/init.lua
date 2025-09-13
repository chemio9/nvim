---@diagnostic disable: inject-field, need-check-nil
local utils = require 'core.utils'
local map = utils.map

--- make client capabilities for lsp
---@return lsp.ClientCapabilities
local function make_capabilities()
  local cap = vim.lsp.protocol.make_client_capabilities()

  -- for nvim-ufo
  cap.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  cap.textDocument.hover.contentFormat = { 'markdown', 'plaintext' }
  cap.textDocument.completion.completionItem = {
    documentationFormat = { 'markdown', 'plaintext' },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
      properties = { 'documentation', 'detail', 'additionalTextEdits' },
    },
  }
  return cap
end

---setup diagnostics for vim
local function setup_diagnostics()
  local icons = require 'core.icons'
  ---@type vim.diagnostic.Opts
  local diagnostics = {
    virtual_text = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focused = false,
      border = 'none',
      source = true,
      header = '',
      prefix = '',
    },
    signs = {
      text = {
        [vim.diagnostic.severity.HINT] = icons.DiagnosticHint,
        [vim.diagnostic.severity.INFO] = icons.DiagnosticInfo,
        [vim.diagnostic.severity.WARN] = icons.DiagnosticWarn,
        [vim.diagnostic.severity.ERROR] = icons.DiagnosticError,
      },
    },
  }

  vim.diagnostic.config(diagnostics)
end

---attach function for lsp
---@param client vim.lsp.Client
---@param bufnr number
local on_attach = function(client, bufnr)
  ---@diagnostic disable-next-line: redefined-local
  local function add_buffer_autocmd(augroup, bufnr, autocmds)
    if not vim.islist(autocmds) then autocmds = { autocmds } end
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

  map('n', '<leader>ewa', vim.lsp.buf.add_workspace_folder, { desc = 'Add workspace folder' })
  map('n', '<leader>ewr', vim.lsp.buf.remove_workspace_folder, { desc = 'Remove workspace folder' })
  map('n', '<leader>ewl',
    function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { desc = 'List workspace folders' })

  map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Declaration' })
  map('n', 'gd', vim.lsp.buf.definition, { desc = 'Definition' })

  -- TODO  glances.nvim or goto-preview
  -- map('n','gp', '<cmd>LspUI peek_definition<CR>',{ desc = 'peek definition' })
  -- if capabilities.documentSymbolProvider then
  --   -- map('n','<leader>co', '<cmd>Lspsaga outline<CR>',{ desc = 'symbols outline' })
  -- end

  map({ 'n', 'v' }, 'grq', function() require('conform').format { async = true, lsp_fallback = true } end,
    { desc = 'format' })
  map('n', 'gra', vim.lsp.buf.code_action, { desc = 'Code action' })

  map('n', 'grh', vim.lsp.buf.hover, { desc = 'Hover details' })
  map('n', 'gri', vim.lsp.buf.implementation, { desc = 'Implementation' })
  map('n', 'grr', vim.lsp.buf.references, { desc = 'References' })
  map('n', 'grn', vim.lsp.buf.rename, { desc = 'Rename' })
  map('n', 'gry', vim.lsp.buf.type_definition, { desc = 'Type Definition' })
  map('n', '<leader>cs', vim.lsp.buf.signature_help, { desc = 'Signature help' })

  if capabilities.workspaceSymbolProvider then
    --@diagnostic disable-next-line: missing-parameter
    map('n', '<leader>cG',
      function()
        vim.ui.input({ prompt = 'Symbol Query: ' },
          function(query) if query then require('telescope.builtin').lsp_workspace_symbols { query = query } end end)
      end, {
        desc = 'Search workspace symbols',
      })
  end

  if capabilities.semanticTokensProvider then
    vim.lsp.semantic_tokens.enable(true, { bufnr = bufnr })
  end

  if capabilities.codeLensProvider then
    if not require('core.utils').has 'lsp-lens.nvim' then
      add_buffer_autocmd('lsp_codelens_refresh', bufnr, {
        events = { 'InsertLeave', 'BufEnter' },
        callback = function()
          if vim.g.codelens_enabled then vim.lsp.codelens.refresh() end
        end,
      })
      vim.lsp.codelens.refresh()
      map('n', '<leader>el', function() vim.lsp.codelens.refresh() end, { desc = 'LSP CodeLens refresh' })
      map('n', '<leader>eL', function() vim.lsp.codelens.run() end, { desc = 'LSP CodeLens run' })
    end
  end

  if capabilities.documentHighlightProvider then
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
  -- TODO looking for a better implementation
  --end
end

utils.autocmd('LspAttach', {
  group = utils.augroup('user_lsp'),
  callback = function(event)
    ---@diagnostic disable-next-line: param-type-mismatch
    on_attach(vim.lsp.get_client_by_id(event.data.client_id), event.buf)
  end,
})

return {
  make_capabilities = make_capabilities,
  setup_diagnostics = setup_diagnostics,
}
