-- System-level setup

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "Warn" },
      { "\nPress any key to continue...", "Normal" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

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
