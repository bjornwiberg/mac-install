-- Neovim configuration entry point
-- This follows the official Neovim Lua guide conventions

-- Load system setup first (Python, undo, swap directories)
require('system')

-- Load plugin management
require('plugins')

-- Load editor settings and keymaps
require('editor')

-- Load LSP configuration
require('lsp')

-- Load plugin-specific configurations
require('plugin-config')

-- Auto reload Lua config files on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.lua" },
  callback = function()
    vim.cmd("source %")
  end,
})
