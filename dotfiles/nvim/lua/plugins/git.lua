return {
  -- Git plugin definitions
  { 'tpope/vim-fugitive' },
  { 'TimUntersberger/neogit' },
  { 'jreybert/vimagit' },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local c = require('tokyonight.colors').setup({ style = 'night' })
      vim.api.nvim_set_hl(0, 'GitSignsAdd',    { fg = c.green })
      vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = c.blue })
      vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = c.red })

      require('gitsigns').setup {
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 500,
          ignore_whitespace = false,
        },
        on_attach = function(bufnr)
          require("scrollbar.handlers.gitsigns").setup()
          local gs = package.loaded.gitsigns
          local opts = { buffer = bufnr }

          -- Preview hunk inline popup
          vim.keymap.set('n', '<leader>Hp', gs.preview_hunk, vim.tbl_extend('force', opts, { desc = 'Preview hunk' }))

          -- Stage / reset / unstage hunk (normal mode)
          vim.keymap.set('n', '<leader>Hs', gs.stage_hunk,       vim.tbl_extend('force', opts, { desc = '(Un)stage hunk' }))
          vim.keymap.set('n', '<leader>Hr', gs.reset_hunk,       vim.tbl_extend('force', opts, { desc = 'Reset hunk' }))

          -- Stage selected lines (visual mode) — like VSCode's "Stage Selected Lines"
          vim.keymap.set('v', '<leader>Hs', function()
            gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end, vim.tbl_extend('force', opts, { desc = 'Stage selected lines' }))
        end,
      }
    end
  }
}
