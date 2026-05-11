-- jsonls setup with SchemaStore-backed schema catalog.
-- Biome owns biome.json (its own schema). Everything else — package.json,
-- tsconfig.json, .prettierrc, GitHub Actions YAML... wait, json — gets
-- schema validation + completion from jsonls.
local ok, schemastore = pcall(require, "schemastore")

vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = ok and schemastore.json.schemas() or nil,
      validate = { enable = true },
    },
  },
})

if not vim.g.jsonls_lsp_enabled then
  vim.lsp.enable("jsonls")
  vim.g.jsonls_lsp_enabled = true
end

