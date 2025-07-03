-- Editor settings

-- Leader key
vim.g.mapleader = ","

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smarttab = true
vim.opt.cindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.splitbelow = true
vim.opt.incsearch = true
vim.opt.ignorecase = true

-- Ensure syntax highlighting is enabled
vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')

-- Dim inactive windows
require('editor.dim-inactive-windows')

-- Auto-reload config on save
require('editor.auto-reload-config')
