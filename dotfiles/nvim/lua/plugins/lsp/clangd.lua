-- clangd — C/C++/Objective-C. Picks up compile_commands.json or
-- compile_flags.txt automatically; no per-project config needed here.
vim.lsp.config("clangd", {})

if not vim.g.clangd_lsp_enabled then
  vim.lsp.enable("clangd")
  vim.g.clangd_lsp_enabled = true
end
