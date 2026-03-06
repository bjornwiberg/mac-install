return {
  -- Editor plugin definitions
  {
    'prettier/vim-prettier',
    config = function()
      -- Editor Plugin Configurations
      -- Setup prettier configuration
      vim.g['prettier#autoformat'] = 0
      vim.g['prettier#autoformat_require_pragma'] = 0
      vim.g['prettier#exec_cmd_async'] = 1

      -- Format on save: skip formatting if Biome is available (Biome's fixAll handles both fixing and formatting)
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.css", "*.scss", "*.html", "*.json", "*.md", "*.yaml", "*.yml" },
        callback = function()
          -- Check if Biome LSP is available - if so, skip formatting (Biome's code action handles it)
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          for _, client in ipairs(clients) do
            if client.name == 'biome' then
              -- Biome handles formatting via fixAll code action, so skip here
              return
            end
          end

          -- Check if biome.json exists by searching upward from the current file's directory
          local file_dir = vim.fn.expand('%:p:h')
          local biome_config = vim.fs.find({ 'biome.json', 'biome.jsonc' }, { upward = true, path = file_dir })[1]

          if biome_config then
            -- Biome project - skip formatting to avoid conflicts (Biome will handle it if attached)
            return
          else
            -- Not a Biome project, try Prettier (will fail silently if not available)
            local ok, _ = pcall(vim.cmd, 'Prettier')
            if not ok then
              -- Prettier not available, try LSP formatting with any available formatter
              for _, client in ipairs(clients) do
                if client.supports_method("textDocument/formatting") then
                  vim.lsp.buf.format({ async = false })
                  return
                end
              end
            end
          end
        end,
      })
    end,
  },
  { 'editorconfig/editorconfig-vim' },

  -- ESLint
  { 'mfussenegger/nvim-lint' },

  -- Commenting
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },
  { 'JoosepAlviste/nvim-ts-context-commentstring' },

  -- Dim inactive windows
  {
    'levouh/tint.nvim',
    config = function()
      require('tint').setup({
        tint = -60,
        saturation = 0.5,
      })
    end,
  },

  -- Other useful plugins
  { "mg979/vim-visual-multi", branch = "master" },
  { 'christoomey/vim-tmux-navigator' },
  { 'tpope/vim-surround' },
  { 'dhruvasagar/vim-zoom' },

  -- GitHub Copilot
  { 'github/copilot.vim' },

  -- Which-key for keybinding help
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
  },
}
