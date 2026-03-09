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
        local clients = vim.lsp.get_clients({ bufnr = bufnr, name = 'biome' })
        if #clients == 0 then return end

        -- Run fixAll code action SYNCHRONOUSLY (must complete before format)
        local result = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', {
          textDocument = { uri = vim.uri_from_bufnr(bufnr) },
          range = {
            start = { line = 0, character = 0 },
            ['end'] = { line = vim.api.nvim_buf_line_count(bufnr), character = 0 },
          },
          context = { only = { 'source.fixAll.biome' }, diagnostics = {} },
        }, 3000)

        if result then
          for _, res in pairs(result) do
            if res.result then
              for _, action in ipairs(res.result) do
                if action.edit then
                  vim.lsp.util.apply_workspace_edit(action.edit, 'utf-8')
                end
              end
            end
          end
        end

        -- Now format (fixAll edits are already applied)
        vim.lsp.buf.format({ name = 'biome', async = false })
      end,
    })
  end,
})
vim.lsp.enable('biome')
