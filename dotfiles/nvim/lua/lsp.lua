-- LSP Configuration
-- This follows the official Neovim Lua guide conventions
local M = {}

-- Override deprecated vim.tbl_islist to prevent warnings
if vim.tbl_islist and vim.islist then
  vim.tbl_islist = vim.islist
end

-- Setup nvim-cmp
local cmp = require'cmp'
local luasnip = require'luasnip'

-- Helper function to check if there are words before cursor
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)  -- For luasnip users.
    end,
  },
  mapping = {
    ['<C-e>'] = cmp.mapping.close(),              -- Close completion menu
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection

    -- Use Ctrl+j/k for completion navigation to avoid Tab conflicts with Copilot
    ["<C-j>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<C-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = 'nvim_lsp' },  -- LSP source
    { name = 'buffer' },    -- Buffer completions
    { name = 'path' },      -- Path completions
  },
})

-- TypeScript LSP setup
require'lspconfig'.ts_ls.setup{
  on_attach = function(client, bufnr)
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)

    -- Auto hover on cursor hold with responsive cursor trap prevention
    local last_cursor_pos = nil
    local window_entered_time = 0

    -- Create autocommand group for hover functionality
    local hover_group = vim.api.nvim_create_augroup('LSPHover', { clear = false })

    vim.api.nvim_create_autocmd({"CursorHold"}, {
      buffer = bufnr,
      group = hover_group,
      callback = function()
        -- Only show hover if we're in normal mode and window is valid
        if vim.api.nvim_get_mode().mode == 'n' and
          vim.api.nvim_get_current_buf() == bufnr then

          local current_pos = vim.api.nvim_win_get_cursor(0)
          local current_time = vim.loop.hrtime()

          -- Don't show hover immediately after window focus or if cursor hasn't moved
          -- Reduced delay from 500ms to 150ms for more responsiveness
          if last_cursor_pos and
            (current_pos[1] ~= last_cursor_pos[1] or current_pos[2] ~= last_cursor_pos[2]) and
            (current_time - window_entered_time) > 150000000 then  -- 150ms in nanoseconds

            vim.lsp.buf.hover()
          end

          last_cursor_pos = current_pos
        end
      end,
    })

    -- Track when window is entered to prevent immediate hover
    vim.api.nvim_create_autocmd({"WinEnter", "FocusGained"}, {
      buffer = bufnr,
      group = hover_group,
      callback = function()
        window_entered_time = vim.loop.hrtime()
        last_cursor_pos = nil  -- Reset cursor tracking
      end,
    })
  end
}

-- Use default LSP hover behavior (no custom handler)
-- Let LSP use default hover handler for proper syntax highlighting

-- Configure signature help for syntax highlighting
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
  focusable = false,
  stylize_markdown = true,
})

-- LSP diagnostic configuration
vim.diagnostic.config({ virtual_lines = true })

-- Prevent the built-in vim.lsp.completion autotrigger from selecting the first item
vim.opt.completeopt = { "menuone", "noselect", "popup" }

-- Set updatetime for auto hover (in milliseconds)
vim.opt.updatetime = 350  -- 350ms (0.35 seconds)

return M
