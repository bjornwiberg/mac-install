-- TypeScript LSP configuration
require('lspconfig').ts_ls.setup{
  on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)

    -- Auto hover on cursor hold with responsive cursor trap prevention
    local last_cursor_pos = nil
    local window_entered_time = 0
    local hover_group = vim.api.nvim_create_augroup('LSPHover', { clear = false })
    vim.api.nvim_create_autocmd({"CursorHold"}, {
      buffer = bufnr,
      group = hover_group,
      callback = function()
        if vim.api.nvim_get_mode().mode == 'n' and vim.api.nvim_get_current_buf() == bufnr then
          local current_pos = vim.api.nvim_win_get_cursor(0)
          local current_time = vim.loop.hrtime()
          if last_cursor_pos and (current_pos[1] ~= last_cursor_pos[1] or current_pos[2] ~= last_cursor_pos[2]) and (current_time - window_entered_time) > 150000000 then
            vim.lsp.buf.hover()
          end
          last_cursor_pos = current_pos
        end
      end,
    })
    vim.api.nvim_create_autocmd({"WinEnter", "FocusGained"}, {
      buffer = bufnr,
      group = hover_group,
      callback = function()
        window_entered_time = vim.loop.hrtime()
        last_cursor_pos = nil
      end,
    })
  end
}
