vim.lsp.config('biome', {
  on_attach = function(client, bufnr)
    -- Biome LSP setup

    -- Add code actions on save - runs Biome's fixAll action automatically on save
    -- This handles things like JSX props sorting and removing unused imports
    -- Then formats the buffer
    -- See: https://willcodefor.beer/posts/biome
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("BiomeFixAll", { clear = true }),
      buffer = bufnr,
      callback = function()
        -- First run fixAll code action (fixes lint issues, sorts props, etc.)
        vim.lsp.buf.code_action({
          context = {
            only = { "source.fixAll.biome" },
            diagnostics = {},
          },
          apply = true,
        })
        -- Then format the buffer
        vim.lsp.buf.format({ name = 'biome', async = false })
      end,
    })
  end,
})
vim.lsp.enable('biome')
