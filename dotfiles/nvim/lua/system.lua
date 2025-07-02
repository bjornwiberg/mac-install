-- System-level setup
local M = {}

-- Set runtime path for plugins
vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath

-- Create Python 3 venv and install pynvim if it is not already installed.
if vim.fn.empty(vim.fn.glob(vim.fn.stdpath('data') .. '/venv')) == 1 then
    vim.fn.system({
        'python3', '-m', 'venv',
        vim.fn.stdpath('data') .. '/venv'
    })
    vim.fn.system({
        vim.fn.stdpath('data') .. '/venv/bin/python3',
        '-m', 'pip', 'install', 'pynvim'
    })
end
vim.g.python3_host_prog = vim.fn.stdpath('data') .. '/venv/bin/python3'

-- Set undo and swap
-- This allows you to undo changes even after closing Vim.
vim.o.undofile = true
vim.o.undoreload = 250
vim.o.undodir = vim.fn.stdpath('data') .. '/undo'
vim.o.directory = vim.fn.stdpath('data') .. '/swap'

-- Create the directories if they do not exist
if not vim.fn.isdirectory(vim.o.undodir) then
  vim.fn.mkdir(vim.o.undodir, 'p')
end
if not vim.fn.isdirectory(vim.o.directory) then
  vim.fn.mkdir(vim.o.directory, 'p')
end

return M
