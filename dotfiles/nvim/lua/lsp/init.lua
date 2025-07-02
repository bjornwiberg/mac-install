-- Global LSP settings
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
  focusable = false,
  stylize_markdown = true,
})

vim.diagnostic.config({ virtual_lines = true })
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.opt.updatetime = 350  -- 350ms (0.35 seconds)

-- Per-server LSP configs
require('lsp.ts')
-- Add more servers as needed, e.g.:
-- require('lsp.lua_ls')
