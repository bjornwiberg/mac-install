-- lua_ls (lua-language-server) — default to Lua 5.4 so standard Lua projects
-- (e.g. things using `//`, `<integer>`, `goto`) don't get false-positive
-- "LuaJIT does not support this grammar" warnings.
--
-- For Neovim config specifically, drop a `.luarc.json` at the nvim config
-- root pinning `runtime.version` to "LuaJIT". The `vim` global and the
-- Neovim runtime library are still injected here so editing init.lua works
-- without per-project setup.
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

if not vim.g.lua_ls_lsp_enabled then
  vim.lsp.enable("lua_ls")
  vim.g.lua_ls_lsp_enabled = true
end
