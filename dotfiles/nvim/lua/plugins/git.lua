return function(use)
  -- Git plugin definitions
  use 'tpope/vim-fugitive'
  use 'TimUntersberger/neogit'
  use 'airblade/vim-gitgutter'
  use 'jreybert/vimagit'

  -- Git Plugin Configurations
  -- Git commit log mappings
  vim.keymap.set('n', '<leader>gl', '<cmd>Magit<CR>', { desc = 'Open Magit (Git interface)' })
end
