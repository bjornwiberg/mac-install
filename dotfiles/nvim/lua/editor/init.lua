-- Editor settings

-- Leader key
vim.g.mapleader = ","

-- Auto-reload files changed outside of Neovim (silently if buffer is unmodified)
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  command = 'if mode() != "c" | silent! checktime | endif',
  desc = 'Check for file changes when Neovim regains focus or buffer is entered',
})
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  callback = function()
    vim.notify('File changed on disk. Buffer reloaded.', vim.log.levels.INFO)
  end,
  desc = 'Notify after auto-reloading a changed file',
})

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

-- Register Dockerfile.* and .env.* variants for filetype detection
vim.filetype.add({
  pattern = {
    ['Dockerfile%..*'] = 'dockerfile',
    ['%.env%..*']      = 'sh',
  },
})

-- Ensure syntax highlighting is enabled
vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')



-- Diagnostic signs
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.INFO]  = "",
      [vim.diagnostic.severity.HINT]  = "",
    },
  },
  float = {
    border = 'rounded',
    source = true,  -- show which LSP/linter the diagnostic comes from
  },
})

