-- Key mappings
local M = {}

-- Key mapping helper
local keymap = vim.keymap.set

-- Claude mappings
local opts = { noremap = true, silent = true }

keymap("n", "<leader>ac", "<cmd>ClaudeCode<cr>", vim.tbl_extend("force", opts, {
  desc = "Toggle Claude",
}))

keymap("n", "<C-a>", "<cmd>ClaudeCodeFocus<cr>", vim.tbl_extend("force", opts, {
  desc = "Focus Claude",
}))

keymap("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", vim.tbl_extend("force", opts, {
  desc = "Resume Claude",
}))

keymap("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", vim.tbl_extend("force", opts, {
  desc = "Continue Claude",
}))

keymap("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", vim.tbl_extend("force", opts, {
  desc = "Select Claude model",
}))

keymap("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", vim.tbl_extend("force", opts, {
  desc = "Add current buffer",
}))

-- Visual mode: send selection
keymap("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", vim.tbl_extend("force", opts, {
  desc = "Send to Claude",
}))

-- File explorers: add file
keymap("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", vim.tbl_extend("force", opts, {
  desc = "Add file",
}))

-- Diff management
keymap("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", vim.tbl_extend("force", opts, {
  desc = "Accept diff",
}))

keymap("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", vim.tbl_extend("force", opts, {
  desc = "Deny diff",
}))

-- Enables navigate out from claude terminal with Ctrl-l
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "fzf" then
      return
    end
    local buf_opts = vim.tbl_extend("force", opts, { buffer = ev.buf })
    vim.keymap.set("t", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>",  buf_opts)
    vim.keymap.set("t", "<C-j>", "<Cmd>TmuxNavigateDown<CR>",  buf_opts)
    vim.keymap.set("t", "<C-k>", "<Cmd>TmuxNavigateUp<CR>",    buf_opts)
    vim.keymap.set("t", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", buf_opts)
  end,
})

-- LSP Key mappings
-- K: show diagnostics if any on current line, otherwise LSP hover
keymap('n', 'K', function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  if #diagnostics > 0 then
    vim.diagnostic.open_float(nil, { focusable = true })
  else
    vim.lsp.buf.hover()
  end
end, { desc = 'Show diagnostics or hover' })

keymap('n', 'grr', '<cmd>FzfLua lsp_references<CR>', { noremap = true, silent = true })
-- rename symbol
keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'Rename symbol' })
-- code action
keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Code action' })

-- Toggle search highlighting
keymap('n', '<Space>', ':set hlsearch! hlsearch?<Bar>:echo<CR>', { silent = true, desc = 'Toggle search highlight' })

  -- Split windows
  keymap('n', '<leader>h', ':split<CR>', { desc = 'Horizontal split' })
  keymap('n', '<leader>v', ':vsplit<CR>', { desc = 'Vertical split' })

-- Close floating windows with Escape
keymap('n', '<Esc>', function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative ~= '' then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  -- If no floating windows, clear search highlighting
  vim.cmd('nohlsearch')
end, { desc = 'Close floating windows or clear search' })

-- Copy selected text to clipboard (visual mode)
keymap('v', 'yc', function()
  -- Use a simpler approach: yank to unnamed register then get it
  vim.cmd('normal! y')
  local text = vim.fn.getreg('"')
  vim.fn.system('pbcopy', text)
  print('Selection copied to clipboard')
end, { desc = 'Copy selection to clipboard' })

-- Move lines up and down (Alt-J and Alt-K on Mac)
keymap('n', '∆', ':m .+1<CR>==', { desc = 'Move line down' })
keymap('n', '˚', ':m .-2<CR>==', { desc = 'Move line up' })
keymap('i', '∆', '<Esc>:m .+1<CR>==gi', { desc = 'Move line down' })
keymap('i', '˚', '<Esc>:m .-2<CR>==gi', { desc = 'Move line up' })
keymap('v', '∆', ':m \'>+1<CR>gv=gv', { desc = 'Move line down' })
keymap('v', '˚', ':m \'<-2<CR>gv=gv', { desc = 'Move line up' })

-- Cmp and Luasnip keymaps
local cmp = require('cmp')
local luasnip = require('luasnip')

-- Set up cmp mappings with luasnip integration
cmp.setup({
  mapping = {
    ['<C-e>'] = cmp.mapping.close(),
    ['<S-down>'] = cmp.mapping.scroll_docs(4),
    ['<S-up>']   = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do cmp.select_next_item({ behavior = cmp.SelectBehavior.Select }) end
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<C-u>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        for _ = 1, 5 do cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select }) end
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if luasnip.expandable() then
          luasnip.expand()
        else
          cmp.confirm({
            select = true,
          })
        end
      else
        fallback()
      end
    end),

    ["<C-j>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
})

-- Key mappings for FZF
vim.keymap.set('n', '<C-p>', '<cmd>FzfLua files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>rg', '<cmd>FzfLua live_grep<CR>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>gc', '<cmd>FzfLua git_commits<CR>', { desc = 'Browse git commits' })
vim.keymap.set('n', '<leader>gs', '<cmd>FzfLua git_status<CR>', { desc = 'Git status' })
vim.keymap.set('n', '<leader>gb', '<cmd>FzfLua git_branches<CR>', { desc = 'Git branches' })
vim.keymap.set('n', '//', '<cmd>FzfLua grep_cword<CR>', { desc = 'Search word under cursor' })
vim.keymap.set('v', '//', '<cmd>FzfLua grep_visual<CR>', { desc = 'Search visual selection' })

-- Neo-tree key mappings
vim.keymap.set('n', '<C-s>', '<cmd>Neotree right focus<CR>', { desc = 'Toggle neo-tree' })
vim.keymap.set('n', '<Leader>b', '<cmd>Neotree buffers float toggle<CR>', { desc = 'Toggle buffers' })

-- Git Plugin Configurations
vim.keymap.set('n', '<leader>gp', '<cmd>Neogit push<CR>', { desc = 'Git push' })

-- Gitgutter mappings
-- Use ]g and [g for navigating git hunks (defined above in diagnostics)
vim.keymap.set('n', ']g', '<cmd>Gitsigns next_hunk<CR>', { desc = 'Next hunk' })
vim.keymap.set('n', '[g', '<cmd>Gitsigns prev_hunk<CR>', { desc = 'Previous hunk' })

-- Markdown preview
vim.keymap.set('n', '<leader>md', '<cmd>MarkdownPreviewToggle<CR>', { desc = 'Toggle markdown preview' })

-- Neotest
vim.keymap.set('n', '<leader>tc', function() require('neotest').run.run() end,                      { desc = 'Run test under cursor' })
vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%:p')) end, { desc = 'Run test file' })
vim.keymap.set('n', '<leader>ta', function() require('neotest').run.run(vim.fn.getcwd()) end,                          { desc = 'Run all vitest tests' })
vim.keymap.set('n', '<leader>tP', function() require('neotest').run.run(vim.fn.getcwd() .. '/playwright') end,        { desc = 'Run all playwright tests' })
vim.keymap.set('n', '<leader>tS', function() require('neotest').run.stop() end,                  { desc = 'Stop test run' })
vim.keymap.set('n', '<leader>ts', function() require('neotest').summary.toggle() end,            { desc = 'Toggle test summary' })
vim.keymap.set('n', '<leader>to', function() require('neotest').output_panel.toggle() end,       { desc = 'Toggle output panel' })
vim.keymap.set('n', '<leader>tO', function() require('neotest').output.open({ enter = true }) end, { desc = 'Open test output' })
vim.keymap.set('n', ']t', function() require('neotest').jump.next({ status = 'failed' }) end,    { desc = 'Jump to next failed test' })
vim.keymap.set('n', '[t', function() require('neotest').jump.prev({ status = 'failed' }) end,    { desc = 'Jump to prev failed test' })

vim.keymap.set('n', '<CR>', '<Plug>(zoom-toggle)', { desc = 'Toggle Zoom' })

return M
