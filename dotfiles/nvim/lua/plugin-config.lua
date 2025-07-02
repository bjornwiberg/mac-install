-- Plugin-specific configurations
local M = {}

-- Setup treesitter (only if available)
local has_treesitter, treesitter = pcall(require, 'nvim-treesitter.configs')
if has_treesitter then
  treesitter.setup {
    ensure_installed = { "typescript", "javascript", "tsx", "json", "html", "css", "lua" },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
  }
end

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

-- Setup nvim-tree (file explorer)
local has_tree, tree = pcall(require, 'nvim-tree')
if has_tree then
  tree.setup({
    sort_by = "case_sensitive",
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false,
    },
  })
end

-- Key mappings for nvim-tree
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader>b', '<cmd>NvimTreeFindFile<CR>', { desc = 'Find current file in explorer' })

-- FZF-lua configuration with icons (only setup if plugin is available)
local fzf_lua_ok, fzf_lua = pcall(require, 'fzf-lua')
if fzf_lua_ok then
  fzf_lua.setup({
    winopts = {
      height = 0.85,
      width = 0.80,
      preview = {
        default = 'bat',
        border = 'border',
        wrap = 'nowrap',
        hidden = 'nohidden',
        vertical = 'down:45%',
        horizontal = 'right:60%',
      },
    },
    keymap = {
      builtin = {
        ["<C-u>"] = "half-page-up",
        ["<C-d>"] = "half-page-down",
      },
      fzf = {
        ["ctrl-u"] = "half-page-up",
        ["ctrl-d"] = "half-page-down",
      },
    },
    files = {
      prompt = 'Files❯ ',
      multiprocess = true,
      git_icons = true,
      file_icons = true,
      color_icons = true,
      cmd = 'rg --files -g "!.git/" --hidden',
      previewer = 'builtin',
    },
    grep = {
      prompt = 'Rg❯ ',
      input_prompt = 'Grep For❯ ',
      multiprocess = true,
      git_icons = true,
      file_icons = true,
      color_icons = true,
      cmd = 'rg --color=always --column -g "!.git/" --hidden -n --no-heading -S',
      previewer = 'builtin',
    },
  })
end

-- Key mappings for FZF
vim.keymap.set('n', '<C-p>', '<cmd>FzfLua files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<leader>rg', '<cmd>FzfLua live_grep<CR>', { desc = 'Live grep' })
vim.keymap.set('n', '<leader>gco', '<cmd>FzfLua git_commits<CR>', { desc = 'Browse git commits' })
vim.keymap.set('n', '<leader>gcs', '<cmd>FzfLua git_status<CR>', { desc = 'Git status' })
vim.keymap.set('n', '<leader>gb', '<cmd>FzfLua git_branches<CR>', { desc = 'Git branches' })

-- Git commit log mappings
vim.keymap.set('n', '<leader>gl', '<cmd>Magit<CR>', { desc = 'Open Magit (Git interface)' })

-- Setup theme
vim.cmd[[colorscheme gruvbox]]

-- Setup status line
local has_lualine, lualine = pcall(require, 'lualine')
if has_lualine then
  lualine.setup {
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  }
end

-- Setup indent guides
local has_ibl, ibl = pcall(require, 'ibl')
if has_ibl then
  local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
  }

  local hooks = require "ibl.hooks"

  -- create the highlight groups in the highlight setup hook, so they are reset
  -- every time the colorscheme changes
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
  end)

  ibl.setup { indent = { highlight = highlight } }
end

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

-- Setup neo-tree file explorer
local has_neo_tree, neo_tree = pcall(require, 'neo-tree')
if has_neo_tree then
  neo_tree.setup({
    filesystem = {
      filtered_items = {
        visible = true, -- when true, they will just be displayed differently than normal items
        never_show = { -- remains hidden even if visible is toggled to true
          ".DS_Store",
        },
      },
      use_libuv_file_watcher = true, -- does not need to be manually refreshed
      follow_current_file  = {
        enabled = true, -- intelligently follow the current file
      },
    },
  })
end

-- Neo-tree key mappings
vim.keymap.set('n', '<C-a>', '<cmd>Neotree right toggle<CR>', { desc = 'Toggle neo-tree' })
vim.keymap.set('n', '<Leader>b', '<cmd>Neotree buffers float toggle<CR>', { desc = 'Toggle buffers' })

return M
