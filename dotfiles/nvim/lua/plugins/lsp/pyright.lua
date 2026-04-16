-- Python LSP configuration (pyright)
vim.lsp.config('pyright', {
  on_attach = function(client, bufnr)
    -- Basic LSP setup
  end
})
vim.lsp.enable('pyright')
