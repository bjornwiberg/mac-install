return {
  -- Git plugin definitions
  { 'tpope/vim-fugitive' },
  { 'TimUntersberger/neogit' },
  { 'jreybert/vimagit' },
  {
    "k2589/getgithublink.nvim",
    config = function()
      require("getgithublink").setup()

      -- Helper: build a GitHub URL for a file path (no line range)
      local function github_file_url(filepath, use_permalink)
        local handle, result

        handle = io.popen('git rev-parse --show-toplevel')
        if not handle then return end
        local git_root = handle:read("*a"):gsub("\n$", "")
        handle:close()

        local relative = filepath:sub(#git_root + 2)

        handle = io.popen('git config --get remote.origin.url')
        if not handle then return end
        result = handle:read("*a")
        handle:close()
        local repo_url = result:gsub("^git@github.com:", "https://github.com/"):gsub("%.git%s*$", "")

        local ref
        if use_permalink then
          handle = io.popen('git rev-parse HEAD')
          if not handle then return end
          ref = handle:read("*a"):gsub("\n$", "")
          handle:close()
        else
          handle = io.popen('git rev-parse --abbrev-ref HEAD')
          if not handle then return end
          ref = handle:read("*a"):gsub("\n$", "")
          handle:close()
        end

        local url = string.format("%s/blob/%s/%s", repo_url, ref, relative)
        vim.fn.setreg('+', url)
        vim.notify("Copied: " .. url, vim.log.levels.INFO)
      end

      vim.api.nvim_create_user_command('GetGithubBranchFileUrl', function()
        github_file_url(vim.fn.expand('%:p'), false)
      end, { desc = 'Copy GitHub file URL (branch)' })

      vim.api.nvim_create_user_command('GetGithubFilePermalink', function()
        github_file_url(vim.fn.expand('%:p'), true)
      end, { desc = 'Copy GitHub file permalink (commit)' })

      -- Expose for neo-tree integration
      _G._github_file_url = github_file_url
    end,
  },
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
