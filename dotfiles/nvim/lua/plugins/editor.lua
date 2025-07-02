vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.INFO]  = "",
      [vim.diagnostic.severity.HINT]  = "",
    },
  },
})

return function(use)
  -- Editor plugin definitions
  use 'prettier/vim-prettier'
  use 'editorconfig/editorconfig-vim'

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
  vim.g['prettier#autoformat'] = 1
  vim.g['prettier#autoformat_require_pragma'] = 0
  vim.g['prettier#exec_cmd_async'] = 1

  -- Format on save using prettier for proper import sorting
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.css", "*.scss", "*.html", "*.json", "*.md", "*.yaml", "*.yml" },
    callback = function()
      vim.cmd('Prettier')
    end,
  })

  -- Key mapping for manual formatting
  vim.keymap.set('n', '<leader>f', '<cmd>Prettier<CR>', { desc = 'Format buffer with prettier' })

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
end
