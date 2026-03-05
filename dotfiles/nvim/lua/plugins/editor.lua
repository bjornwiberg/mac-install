vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.INFO]  = "",
      [vim.diagnostic.severity.HINT]  = "",
    },
  },
})

return function(use)
  -- Editor plugin definitions
  use 'prettier/vim-prettier'
  use 'editorconfig/editorconfig-vim'

  -- ESLint
  use 'mfussenegger/nvim-lint'

  -- Commenting
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  -- Other useful plugins
  use { "mg979/vim-visual-multi", branch = "master" }
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-surround'
  use 'dhruvasagar/vim-zoom'
  use {
    "rosstang/dimit.nvim",
    config = function()
      require("dimit").setup()
    end,
  }

  -- GitHub Copilot
  use 'github/copilot.vim'

  -- Which-key for keybinding help
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {}
    end
  }

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

  -- Setup commenting
  local has_comment, comment = pcall(require, 'Comment')
  if has_comment then
    comment.setup()
  end

  -- Setup context commenting
  local has_ts_context, ts_context = pcall(require, 'ts_context_commentstring')
  if has_ts_context then
    ts_context.setup()
  end

  -- Setup which-key
  local has_which_key, which_key = pcall(require, 'which-key')
  if has_which_key then
    which_key.setup {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  end

  -- Markdown preview
use({
  "iamcco/markdown-preview.nvim",
  run = function() vim.fn["mkdp#util#install"]() end,
})

end
