return function(use)
  -- Git plugin definitions
  use 'tpope/vim-fugitive'
  use 'TimUntersberger/neogit'
  use 'jreybert/vimagit'
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup {
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 500,
          ignore_whitespace = false,
        },
      }
    end
  }

  -- Git Plugin Configurations
  -- Git commit log mappings
  vim.keymap.set('n', '<leader>gl', '<cmd>Magit<CR>', { desc = 'Open Magit (Git interface)' })
end
