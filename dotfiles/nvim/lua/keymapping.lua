-- Key mappings
local M = {}

-- Key mapping helper
local keymap = vim.keymap.set

-- Claude mappings
local opts = { noremap = true, silent = true }

keymap("n", "<C-a>", "<cmd>ClaudeCodeFocus<cr>", vim.tbl_extend("force", opts, {
  desc = "Focus Claude",
}))

keymap("n", "<leader>ac", "<cmd>ClaudeCode<cr>", vim.tbl_extend("force", opts, {
  desc = "Toggle Claude",
}))

keymap("n", "<leader>aR", "<cmd>ClaudeCode --resume<cr>", vim.tbl_extend("force", opts, {
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
keymap("n", "<leader>af", "<cmd>ClaudeCodeTreeAdd<cr>", vim.tbl_extend("force", opts, {
  desc = "Add file",
}))

-- Diff management
keymap("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", vim.tbl_extend("force", opts, {
  desc = "Accept diff",
}))

keymap("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", vim.tbl_extend("force", opts, {
  desc = "Deny diff",
}))

keymap("n", "<leader>aY", "<cmd>ClaudeCode --dangerously-skip-permissions<cr>", vim.tbl_extend("force", opts, {
  desc = "Claude (skip permissions)",
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

keymap('n', 'grr', '<cmd>FzfLua lsp_references<CR>', { noremap = true, silent = true })

-- Toggle search highlighting
keymap('n', '<Space>', ':set hlsearch! hlsearch?<Bar>:echo<CR>', { silent = true, desc = 'Toggle search highlight' })

-- Zen mode
keymap('n', '<C-w>z', function() Snacks.zen() end, { desc = 'Toggle zen mode' })

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

-- Word movement in insert mode
keymap('i', '<C-h>', '<S-Left>', { desc = 'Move word left' })
keymap('i', '<C-l>', '<S-Right>', { desc = 'Move word right' })

keymap('v', '∆', ':m \'>+1<CR>gv=gv', { desc = 'Move line down' })
keymap('v', '˚', ':m \'<-2<CR>gv=gv', { desc = 'Move line up' })

-- Pickers (Snacks)
vim.keymap.set('n', '<C-p>', function()
  Snacks.picker.smart({
    hidden = true,
    ignored = true,
    filter = { cwd = true },
  })
end, { desc = 'Find files (smart)' })
vim.keymap.set('n', '<leader>rg', function() Snacks.picker.grep() end, { desc = 'Live grep' })

-- Git
vim.keymap.set('n', '<leader>gc', function() Snacks.picker.git_log() end, { desc = 'Git commits' })
vim.keymap.set('n', '<leader>gs', function() Snacks.picker.git_status({ show_empty = true }) end, { desc = 'Git status' })
vim.keymap.set('n', '<leader>gb', function()
  Snacks.picker.git_branches({
    all = true,
    cmd_args = { "--sort=-committerdate" },
    sort = { fields = { "score:desc", "idx" } },
    matcher = { sort_empty = false, fuzzy = true, smartcase = true },
  })
end, { desc = 'Git branches' })
vim.keymap.set('n', '<leader>gS', function()
  local bcache = require('gitsigns.cache').cache[vim.api.nvim_get_current_buf()]
  if not bcache then return end
  local gs = require('gitsigns')
  if vim.tbl_isempty(bcache.staged_diffs) then gs.stage_buffer() else gs.reset_buffer_index() end
end, { desc = '(Un)stage buffer' })
vim.keymap.set('n', '<leader>N',  '<cmd>Neogit<CR>', { desc = 'Neogit' })
vim.keymap.set('n', '//', function() Snacks.picker.grep_word() end, { desc = 'Search word under cursor' })
vim.keymap.set('v', '//', function() Snacks.picker.grep_word() end, { desc = 'Search visual selection' })
vim.keymap.set('n', '<leader>km', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>ghr', function() Snacks.gh.pr() end, { desc = 'GitHub PRs' })

-- File explorer
vim.keymap.set('n', '<C-s>', function() Snacks.explorer.open() end, { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<Leader>b', '<cmd>Neotree buffers float toggle<CR>', { desc = 'Toggle buffers' })

-- Git Plugin Configurations
vim.keymap.set('n', '<leader>gp', function()
  local branch = vim.trim(vim.fn.system('git branch --show-current'))
  vim.notify('Pushing ' .. branch .. '...', vim.log.levels.INFO)
  vim.fn.jobstart({ 'git', 'push', '-u', 'origin', 'HEAD' }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 then
          vim.notify('Pushed ' .. branch .. ' successfully', vim.log.levels.INFO)
        else
          vim.notify('Push ' .. branch .. ' failed (exit ' .. code .. ')', vim.log.levels.ERROR)
        end
      end)
    end,
  })
end, { desc = 'Git push (set upstream)' })
vim.keymap.set('n', '<leader>gP', function()
  local branch = vim.trim(vim.fn.system('git branch --show-current'))
  vim.notify('Pulling ' .. branch .. '...', vim.log.levels.INFO)
  vim.fn.jobstart({ 'git', 'pull' }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 then
          vim.notify('Pulled ' .. branch .. ' successfully', vim.log.levels.INFO)
          vim.cmd('checktime')
        else
          vim.notify('Pull ' .. branch .. ' failed (exit ' .. code .. ')', vim.log.levels.ERROR)
        end
      end)
    end,
  })
end, { desc = 'Git pull' })

-- Gitgutter mappings
-- Use ]g and [g for navigating git hunks (defined above in diagnostics)
vim.keymap.set('n', ']g', '<cmd>Gitsigns next_hunk<CR>', { desc = 'Next hunk' })
vim.keymap.set('n', '[g', '<cmd>Gitsigns prev_hunk<CR>', { desc = 'Previous hunk' })
-- Github URLs (snacks.gitbrowse)
local function copy_url(url) vim.fn.setreg('+', url); vim.notify("Copied: " .. url) end
local function copy_url_no_lines(url) url = url:gsub("#L%d+%-L%d+$", ""); copy_url(url) end
vim.keymap.set('n', '<leader>ghf', function() Snacks.gitbrowse({ what = "file", open = copy_url_no_lines }) end, { desc = 'Copy Github file URL' })
vim.keymap.set('v', '<leader>ghf', function() Snacks.gitbrowse({ what = "file", open = copy_url }) end, { desc = 'Copy Github file URL (lines)' })
vim.keymap.set('n', '<leader>ghp', function() Snacks.gitbrowse({ what = "permalink", open = copy_url_no_lines }) end, { desc = 'Copy Github permalink' })
vim.keymap.set('v', '<leader>ghp', function() Snacks.gitbrowse({ what = "permalink", open = copy_url }) end, { desc = 'Copy Github permalink (lines)' })

-- Node package manager (auto-detect yarn/pnpm/npm)
local function node_detect_pm()
  local cwd = vim.fn.getcwd()
  if vim.fs.find('yarn.lock', { upward = true, path = cwd })[1] then return 'yarn' end
  if vim.fs.find('pnpm-lock.yaml', { upward = true, path = cwd })[1] then return 'pnpm' end
  if vim.fs.find('package-lock.json', { upward = true, path = cwd })[1] then return 'npm' end
  return nil
end

vim.keymap.set('n', '<leader>ni', function()
  local pm = node_detect_pm()
  if not pm then
    vim.notify('No lockfile found', vim.log.levels.WARN)
    return
  end
  local cmd = pm .. ' install'
  local output = {}
  local start = vim.loop.hrtime()
  vim.notify('Running ' .. cmd .. '...', vim.log.levels.INFO, { title = 'Node' })
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data) if data then vim.list_extend(output, data) end end,
    on_stderr = function(_, data) if data then vim.list_extend(output, data) end end,
    on_exit = function(_, code)
      vim.schedule(function()
        local elapsed = string.format('%.1fs', (vim.loop.hrtime() - start) / 1e9)
        if code == 0 then
          vim.notify('✓ ' .. cmd .. ' completed in ' .. elapsed, vim.log.levels.INFO, { title = 'Node', timeout = 5000 })
        else
          vim.notify('✗ ' .. cmd .. ' failed:\n' .. table.concat(output, '\n'), vim.log.levels.ERROR, { title = 'Node' })
        end
      end)
    end,
  })
end, { desc = 'Node install (auto-detect)' })

vim.keymap.set('n', '<leader>na', function()
  local pm = node_detect_pm()
  if not pm then
    vim.notify('No lockfile found', vim.log.levels.WARN)
    return
  end
  local cmd = pm .. ' audit'
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.min(90, math.floor(vim.o.columns * 0.8))
  local height = math.floor(vim.o.lines * 0.8)
  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' ' .. cmd .. ' ',
    title_pos = 'center',
  })
  vim.fn.termopen(cmd)
  vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = buf, nowait = true })
end, { desc = 'Node audit (auto-detect)' })

-- Search and Replace (grug-far)
vim.keymap.set({ 'n', 'x' }, '<leader>sr', function()
  local grug = require("grug-far")
  local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
  grug.open({
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= "" and "*." .. ext or nil,
    },
  })
end, { desc = 'Search and Replace' })

-- Markdown preview
vim.keymap.set('n', '<leader>mdp', '<cmd>RenderMarkdown toggle<CR>', { desc = 'Toggle markdown render' })
vim.keymap.set('n', '<leader>mdb', '<cmd>MarkdownPreviewToggle<CR>', { desc = 'Markdown preview (browser)' })

-- Restart tmux pane (send C-c, then re-run last command)
vim.keymap.set('n', '<leader>rp', function()
  local current_pane = vim.fn.system('tmux display-message -p "#{pane_index}"'):gsub("%s+$", "")
  local output = vim.fn.system('tmux list-panes -F "#{pane_index}|#{@name}|#{pane_current_command}"')

  local panes = {}
  for line in output:gmatch("[^\n]+") do
    local idx, name, cmd = line:match("^(%d+)|([^|]*)|(.+)$")
    if idx and idx ~= current_pane then
      local label = (name and name ~= "") and name or cmd
      table.insert(panes, { target = ":." .. idx, label = label })
    end
  end

  if #panes == 0 then
    vim.notify("No other panes in this window", vim.log.levels.WARN)
    return
  end

  local lines = { " Restart pane:" }
  for i, p in ipairs(panes) do
    table.insert(lines, "  " .. i .. ": " .. p.label)
  end

  local width = 0
  for _, l in ipairs(lines) do width = math.max(width, #l) end
  width = math.max(width + 2, 20)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = math.floor((vim.o.lines - #lines) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = #lines,
    style = "minimal",
    border = "rounded",
  })

  -- Highlight the header
  vim.api.nvim_buf_add_highlight(buf, -1, "Title", 0, 0, -1)

  local function close()
    if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
    if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
  end

  -- Map number keys and escape/q to close
  for i, p in ipairs(panes) do
    vim.keymap.set("n", tostring(i), function()
      close()
      vim.fn.system("tmux send-keys -t " .. p.target .. " C-c")
      vim.defer_fn(function()
        vim.fn.system("tmux send-keys -t " .. p.target .. " Up Enter")
        vim.notify("Restarted: " .. p.label, vim.log.levels.INFO)
      end, 200)
    end, { buffer = buf, nowait = true })
  end

  for _, key in ipairs({ "q", "<Esc>", "<C-c>" }) do
    vim.keymap.set("n", key, close, { buffer = buf, nowait = true })
  end
end, { desc = 'Restart tmux pane' })

-- Run current file (detects filetype and finds appropriate runner)
vim.keymap.set('n', '<leader>rf', function()
  local file = vim.fn.expand('%:p')
  local ft = vim.bo.filetype
  local runners = {
    python = function()
      local venv = vim.fn.getcwd() .. '/venv/bin/python'
      return (vim.fn.filereadable(venv) == 1 and venv or 'python3') .. ' ' .. file
    end,
    javascript = function() return 'node ' .. file end,
    typescript = function() return 'npx tsx ' .. file end,
    lua = function() return 'lua ' .. file end,
    sh = function() return 'bash ' .. file end,
    zsh = function() return 'zsh ' .. file end,
    ruby = function() return 'ruby ' .. file end,
    go = function() return 'go run ' .. file end,
    rust = function() return 'cargo run' end,
  }
  local runner = runners[ft]
  if runner then
    local cmd = runner()
    local buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    vim.api.nvim_open_win(buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      col = math.floor((vim.o.columns - width) / 2),
      row = math.floor((vim.o.lines - height) / 2),
      style = 'minimal',
      border = 'rounded',
      title = ' ' .. cmd .. ' ',
      title_pos = 'center',
    })
    vim.fn.termopen(cmd)
    vim.cmd('startinsert')
  else
    vim.notify('No runner configured for filetype: ' .. ft, vim.log.levels.WARN)
  end
end, { desc = 'Run current file' })

-- Neotest
vim.keymap.set('n', '<leader>tc', function() require('neotest').run.run() end,                      { desc = 'Run test under cursor' })
vim.keymap.set('n', '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%:p')) end, { desc = 'Run test file' })
vim.keymap.set('n', '<leader>ta', function() require('neotest').run.run(vim.fn.getcwd()) end,                          { desc = 'Run all vitest tests' })
vim.keymap.set('n', '<leader>tP', function() require('neotest').run.run(vim.fn.getcwd() .. '/playwright') end,        { desc = 'Run all playwright tests' })
vim.keymap.set('n', '<leader>tS', function() require('neotest').run.stop() end,                  { desc = 'Stop test run' })
vim.keymap.set('n', '<leader>ts', function() require('neotest').summary.toggle() end,            { desc = 'Toggle test summary' })
vim.keymap.set('n', '<leader>to', function() require('neotest').output_panel.toggle() end,       { desc = 'Toggle output panel' })
vim.keymap.set('n', '<leader>tO', function() require('neotest').output.open({ enter = true }) end, { desc = 'Open test output' })
vim.keymap.set('n', ']t', function() require('neotest').jump.next() end, { desc = 'Jump to next test' })
vim.keymap.set('n', '[t', function() require('neotest').jump.prev() end, { desc = 'Jump to prev test' })

return M
