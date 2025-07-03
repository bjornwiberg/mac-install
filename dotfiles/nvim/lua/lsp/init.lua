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
require('lsp.ts')
-- Add more servers as needed, e.g.:
-- require('lsp.lua_ls')
