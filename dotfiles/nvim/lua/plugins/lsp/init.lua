local M = {}

-- Plugin definitions
M.plugins = function(use)
  -- LSP plugin definitions
  use {
    'neovim/nvim-lspconfig',
  }

  -- LSP Autocompletion plugin definitions
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip'
end

-- LSP setup and configuration
M.setup = function()
  -- Global LSP settings
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    focusable = false,
    stylize_markdown = true,
  })

  vim.diagnostic.config({ virtual_lines = true })
  vim.opt.completeopt = { "menuone", "noselect", "popup" }
  vim.opt.updatetime = 350  -- 350ms (0.35 seconds)

  -- LSP Autocompletion configuration
  local cmp = require'cmp'
  local luasnip = require'luasnip'
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'path' },
    },
  })

  -- Per-server LSP configs
  require('plugins.lsp.ts')
  -- Add more servers as needed, e.g.:
  -- require('plugins.lsp.lua_ls')
end

return M
