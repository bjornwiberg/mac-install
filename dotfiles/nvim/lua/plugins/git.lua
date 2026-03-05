return {
  -- Git plugin definitions
  { 'tpope/vim-fugitive' },
  { 'TimUntersberger/neogit' },
  { 'jreybert/vimagit' },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup {
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 500,
          ignore_whitespace = false,
        },
        on_attach = function()
          require("scrollbar.handlers.gitsigns").setup()
        end,
      }
    end
  }
}
