-- Key mappings
local M = {}

-- Key mapping helper
local keymap = vim.keymap.set

-- -- LSP Key mappings
keymap('n', 'grr', '<cmd>FzfLua lsp_references<CR>', { noremap = true, silent = true })

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
vim.keymap.set('n', '<leader>gco', '<cmd>FzfLua git_commits<CR>', { desc = 'Browse git commits' })
vim.keymap.set('n', '<leader>gcs', '<cmd>FzfLua git_status<CR>', { desc = 'Git status' })
vim.keymap.set('n', '<leader>gb', '<cmd>FzfLua git_branches<CR>', { desc = 'Git branches' })
vim.keymap.set('n', '//', '<cmd>FzfLua grep_cword<CR>', { desc = 'Search word under cursor' })
vim.keymap.set('v', '//', '<cmd>FzfLua grep_visual<CR>', { desc = 'Search visual selection' })

-- Neo-tree key mappings
vim.keymap.set('n', '<C-a>', '<cmd>Neotree right toggle<CR>', { desc = 'Toggle neo-tree' })
vim.keymap.set('n', '<Leader>b', '<cmd>Neotree buffers float toggle<CR>', { desc = 'Toggle buffers' })

-- Git Plugin Configurations
-- Git commit log mappings
vim.keymap.set('n', '<leader>gg', '<cmd>Magit<CR>', { desc = 'Open Magit (Git interface)' })
vim.keymap.set('n', '<leader>gp', '<cmd>Neogit push<CR>', { desc = 'Git push' })

return M
