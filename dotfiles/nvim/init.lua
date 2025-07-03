-- Neovim configuration entry point
-- This follows the official Neovim Lua guide conventions

-- Bootstrap Neovim with essential settings
require('bootstrap')

-- Load editor settings and keymaps
require('editor')

-- Load plugin management
require('plugins')

-- Load LSP configuration
require('plugins.lsp').setup()

-- Load key mappings (after all plugins are loaded)
require('keymapping')
