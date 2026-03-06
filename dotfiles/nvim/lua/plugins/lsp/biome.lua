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
        local clients = vim.lsp.get_clients({ bufnr = bufnr, name = 'biome' })
        if #clients == 0 then return end
        clients[1].request('textDocument/codeAction', {
          textDocument = { uri = vim.uri_from_bufnr(bufnr) },
          range = {
            start = { line = 0, character = 0 },
            ['end'] = { line = vim.api.nvim_buf_line_count(bufnr), character = 0 },
          },
          context = { only = { 'source.fixAll.biome' }, diagnostics = {} },
        }, function(_, actions)
          if actions and #actions > 0 then
            for _, action in ipairs(actions) do
              if action.edit then
                vim.lsp.util.apply_workspace_edit(action.edit, 'utf-8')
              end
            end
          end
        end, bufnr)
        -- Then format the buffer
        vim.lsp.buf.format({ name = 'biome', async = false })
      end,
    })
  end,
})
vim.lsp.enable('biome')
