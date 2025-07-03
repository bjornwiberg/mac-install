-- Auto-reload config on save
vim.api.nvim_create_augroup("AutoSourcing", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "AutoSourcing",
  pattern = { "*.lua" },
  callback = function()
    vim.cmd("source %")
  end,
})
