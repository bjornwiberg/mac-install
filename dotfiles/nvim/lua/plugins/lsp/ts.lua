-- TypeScript LSP configuration
vim.lsp.config('ts_ls', {
  on_attach = function(client, bufnr)
    -- Basic LSP setup
  end
})
vim.lsp.enable('ts_ls')
