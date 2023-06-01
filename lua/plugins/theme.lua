return {
  {
    'olimorris/onedarkpro.nvim',
    priority = 1000, -- Ensure it loads first
    opts = {
      plugins = {
        aerial = false,
        barbar = false,
        copilot = false,
        dashboard = true,
        gitsigns = true,
        hop = true,
        indentline = true,
        leap = true,
        lsp_saga = true,
        lsp_semantic_tokens = true,
        marks = false,
        neotest = false,
        neo_tree = true,
        nvim_cmp = true,
        nvim_bqf = false,
        nvim_dap = true,
        nvim_dap_ui = true,
        nvim_hlslens = true,
        nvim_lsp = true,
        nvim_navic = false,
        nvim_notify = true,
        nvim_tree = false,
        nvim_ts_rainbow = false,
        op_nvim = false,
        packer = false,
        polygot = false,
        startify = false,
        telescope = true,
        toggleterm = true,
        treesitter = true,
        trouble = true,
        vim_ultest = false,
        which_key = true,
      },
      styles = {
        -- For example, to apply bold and italic, use "bold,italic"
        types = 'bold',        -- Style that is applied to types
        methods = 'NONE',      -- Style that is applied to methods
        numbers = 'NONE',      -- Style that is applied to numbers
        strings = 'NONE',      -- Style that is applied to strings
        comments = 'italic',     -- Style that is applied to comments
        keywords = 'bold',     -- Style that is applied to keywords
        constants = 'NONE',    -- Style that is applied to constants
        functions = 'NONE',    -- Style that is applied to functions
        operators = 'NONE',    -- Style that is applied to operators
        variables = 'NONE',    -- Style that is applied to variables
        parameters = 'NONE',   -- Style that is applied to parameters
        conditionals = 'NONE', -- Style that is applied to conditionals
        virtual_text = 'NONE', -- Style that is applied to virtual text
      },
      options = {
        cursorline = true,                  -- Use cursorline highlighting?
        transparency = true,               -- Use a transparent background?
        terminal_colors = true,             -- Use the theme's colors for Neovim's :terminal?
        highlight_inactive_windows = false, -- When the window is out of focus, change the normal background?
      },
    },
  },
}
