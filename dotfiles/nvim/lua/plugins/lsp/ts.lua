-- TypeScript LSP configuration
local keymapping = require('keymapping')

require('lspconfig').ts_ls.setup{
  on_attach = function(client, bufnr)
    -- Set up standard LSP keymappings
    keymapping.setup_lsp_keymaps(client, bufnr)

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
