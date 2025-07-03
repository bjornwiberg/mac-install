-- Editor settings and keymaps
local M = {}

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

-- Dim inactive windows using colorcolumn
local function dim_inactive_windows()
  local current_win = vim.api.nvim_get_current_win()
  local wins = vim.api.nvim_tabpage_list_wins(0)

  for _, win in ipairs(wins) do
    local range = ""
    if win ~= current_win then
      local width
      if vim.wo[win].wrap then
        width = 256 -- max width for wrapped lines
      else
        width = vim.api.nvim_win_get_width(win)
      end
      local columns = {}
      for i = 1, width do
        table.insert(columns, tostring(i))
      end
      range = table.concat(columns, ',')
    end
    vim.wo[win].colorcolumn = range
  end
end

-- Auto commands for dimming inactive windows and cursor line
vim.api.nvim_create_augroup("DimInactiveWindows", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", {
  group = "DimInactiveWindows",
  callback = function()
    dim_inactive_windows()
    vim.opt_local.cursorline = true
  end,
})
vim.api.nvim_create_autocmd("WinLeave", {
  group = "DimInactiveWindows",
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- Toggle relative line numbers based on focus/mode
vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd({"BufEnter", "FocusGained", "InsertLeave", "WinEnter"}, {
  group = "NumberToggle",
  callback = function()
    if vim.bo.buftype == "" then
      vim.wo.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({"BufLeave", "FocusLost", "InsertEnter", "WinLeave"}, {
  group = "NumberToggle",
  callback = function()
    if vim.bo.buftype == "" then
      vim.wo.relativenumber = false
    end
  end,
})

-- Auto-reload config on save
vim.api.nvim_create_augroup("AutoSourcing", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "AutoSourcing",
  pattern = { "*.lua" },
  callback = function()
    vim.cmd("source %")
  end,
})

return M
