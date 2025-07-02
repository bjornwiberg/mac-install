-- Override deprecated vim.tbl_islist to prevent warnings
if vim.tbl_islist and vim.islist then
  vim.tbl_islist = vim.islist
end

vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath

local fn = vim.fn
local cmd = vim.cmd
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Create Python 3 venv and install pynvim if it is not already installed.
if vim.fn.empty(vim.fn.glob(vim.fn.stdpath('data') .. '/venv')) == 1 then
    vim.fn.system({
        'python3', '-m', 'venv',
        vim.fn.stdpath('data') .. '/venv'
    })
    vim.fn.system({
        vim.fn.stdpath('data') .. '/venv/bin/python3',
        '-m', 'pip', 'install', 'pynvim'
    })
end
vim.g.python3_host_prog = vim.fn.stdpath('data') .. '/venv/bin/python3'

-- Set undo and swap
-- This allows you to undo changes even after closing Vim.
vim.o.undofile = true
vim.o.undoreload = 250
vim.o.undodir = fn.stdpath('data') .. '/undo'
vim.o.directory = fn.stdpath('data') .. '/swap'
-- Create the directories if they do not exist
if not fn.isdirectory(vim.o.undodir) then
  fn.mkdir(vim.o.undodir, 'p')
end
if not fn.isdirectory(vim.o.directory) then
  fn.mkdir(vim.o.directory, 'p')
end

return require('packer').startup(function(use)
  -- LSP and related plugins
  use 'neovim/nvim-lspconfig'  -- LSP configurations
  use 'hrsh7th/nvim-cmp'       -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'   -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer'      -- Buffer completions
  use 'hrsh7th/cmp-path'        -- Path completions
  use 'hrsh7th/cmp-cmdline'     -- Command line completions
  use 'saadparwaiz1/cmp_luasnip' -- Snippet completions
  use 'L3MON4D3/LuaSnip'        -- Snippet engine

  -- Treesitter for better syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

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

  -- Setup nvim-cmp.
  local cmp = require'cmp'
  local luasnip = require'luasnip'

  -- Helper function to check if there are words before cursor
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)  -- For luasnip users.
      end,
    },
    mapping = {
      ['<C-e>'] = cmp.mapping.close(),              -- Close completion menu
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection

      -- Use Ctrl+j/k for completion navigation to avoid Tab conflicts with Copilot
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
    sources = {
      { name = 'nvim_lsp' },  -- LSP source
      { name = 'buffer' },    -- Buffer completions
      { name = 'path' },      -- Path completions
    },
  })

  require'lspconfig'.ts_ls.setup{
    on_attach = function(client, bufnr)
      local opts = { noremap=true, silent=true }
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)

      -- Auto hover on cursor hold with responsive cursor trap prevention
      local last_cursor_pos = nil
      local window_entered_time = 0

      vim.api.nvim_create_autocmd({"CursorHold"}, {
        buffer = bufnr,
        callback = function()
          -- Only show hover if we're in normal mode and window is valid
          if vim.api.nvim_get_mode().mode == 'n' and
            vim.api.nvim_get_current_buf() == bufnr then

            local current_pos = vim.api.nvim_win_get_cursor(0)
            local current_time = vim.loop.hrtime()

            -- Don't show hover immediately after window focus or if cursor hasn't moved
            -- Reduced delay from 500ms to 150ms for more responsiveness
            if last_cursor_pos and
              (current_pos[1] ~= last_cursor_pos[1] or current_pos[2] ~= last_cursor_pos[2]) and
              (current_time - window_entered_time) > 150000000 then  -- 150ms in nanoseconds

              vim.lsp.buf.hover()
            end

            last_cursor_pos = current_pos
          end
        end,
      })

      -- Track when window is entered to prevent immediate hover
      vim.api.nvim_create_autocmd({"WinEnter", "FocusGained"}, {
        buffer = bufnr,
        callback = function()
          window_entered_time = vim.loop.hrtime()
          last_cursor_pos = nil  -- Reset cursor tracking
        end,
      })
    end
  }

  vim.diagnostic.config({ virtual_lines = true })
  -- prevent the built-in vim.lsp.completion autotrigger from selecting the first item
  vim.opt.completeopt = { "menuone", "noselect", "popup" }

  -- Set updatetime for auto hover (in milliseconds)
  vim.opt.updatetime = 350  -- 350ms (0.35 seconds)

  -- Leader key
  vim.g.mapleader = ","

  -- Basic settings
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.smarttab = true
  vim.opt.cindent = true
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true
  vim.opt.wrap = false
  vim.opt.splitbelow = true
  vim.opt.incsearch = true
  vim.opt.ignorecase = true

  -- Ensure syntax highlighting is enabled
  vim.cmd('syntax enable')
  vim.cmd('filetype plugin indent on')

  -- Dim inactive windows using colorcolumn
  local function dim_inactive_windows()
    local current_win = vim.api.nvim_get_current_win()
    local wins = vim.api.nvim_tabpage_list_wins(0)

    for _, win in ipairs(wins) do
      local range = ""
      if win ~= current_win then
        local width
        if vim.wo[win].wrap then
          width = 256 -- max width for wrapped lines
        else
          width = vim.api.nvim_win_get_width(win)
        end
        local columns = {}
        for i = 1, width do
          table.insert(columns, tostring(i))
        end
        range = table.concat(columns, ',')
      end
      vim.wo[win].colorcolumn = range
    end
  end

  -- Auto commands for dimming inactive windows and cursor line
  vim.api.nvim_create_augroup("DimInactiveWindows", { clear = true })
  vim.api.nvim_create_autocmd("WinEnter", {
    group = "DimInactiveWindows",
    callback = function()
      dim_inactive_windows()
      vim.opt_local.cursorline = true
    end,
  })
  vim.api.nvim_create_autocmd("WinLeave", {
    group = "DimInactiveWindows",
    callback = function()
      vim.opt_local.cursorline = false
    end,
  })

  -- Toggle relative line numbers based on focus/mode
  vim.api.nvim_create_augroup("NumberToggle", { clear = true })
  vim.api.nvim_create_autocmd({"BufEnter", "FocusGained", "InsertLeave", "WinEnter"}, {
    group = "NumberToggle",
    callback = function()
      if vim.bo.buftype == "" then
        vim.wo.relativenumber = true
      end
    end,
  })
  vim.api.nvim_create_autocmd({"BufLeave", "FocusLost", "InsertEnter", "WinLeave"}, {
    group = "NumberToggle",
    callback = function()
      if vim.bo.buftype == "" then
        vim.wo.relativenumber = false
      end
    end,
  })

  -- Auto-reload config on save
  vim.api.nvim_create_augroup("AutoSourcing", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = "AutoSourcing",
    pattern = { "config.lua" },
    callback = function()
      vim.cmd("source %")
    end,
  })

  -- Key mappings
  local keymap = vim.keymap.set

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
  keymap('v', '∆', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
  keymap('v', '˚', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

  -- Toggle search highlighting
  keymap('n', '<Space>', ':set hlsearch! hlsearch?<Bar>:echo<CR>', { silent = true, desc = 'Toggle search highlight' })

  -- Split windows
  keymap('n', ',h', ':split<CR>', { desc = 'Horizontal split' })
  keymap('n', ',v', ':vsplit<CR>', { desc = 'Vertical split' })

  use 'github/copilot.vim'

  -- color indent
    use "lukas-reineke/indent-blankline.nvim"
    require("ibl").setup()

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

  require("ibl").setup { indent = { highlight = highlight } }


  -- commenting
    use {
      'numToStr/Comment.nvim',
      config = function()
          require('Comment').setup()
      end
    }
    use 'JoosepAlviste/nvim-ts-context-commentstring'

  -- theme
  use 'ellisonleao/gruvbox.nvim'
  vim.cmd[[colorscheme gruvbox]]

  -- tab bar plugin
  use {
    'romgrk/barbar.nvim',
    requires = {'nvim-tree/nvim-web-devicons'}
  }

  use {
  'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  require('lualine').setup {
    -- theme = 'tokyonight',
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {'encoding', 'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  }

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  use { "mg979/vim-visual-multi", branch = "master" }
  use 'airblade/vim-gitgutter'
  use 'christoomey/vim-tmux-navigator'
  use 'tpope/vim-surround'
  use 'ryanoasis/vim-devicons'
  use 'edkolev/tmuxline.vim'
  use 'dhruvasagar/vim-zoom'
  use 'jreybert/vimagit'
  use 'frazrepo/vim-rainbow'
  use("petertriho/nvim-scrollbar")



  -- file explorer
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim"
    },
    config = function ()
      require("neo-tree").setup({
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

      vim.cmd([[nnoremap <C-a> :Neotree right toggle<cr>]])
      vim.cmd([[nnoremap <Leader>b :Neotree buffers float toggle<cr>]])
    end
  }

        -- Prettier for proper formatting with import sorting
    use 'prettier/vim-prettier'

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

      use 'editorconfig/editorconfig-vim'

    -- FZF with icons using fzf-lua (better icon support)
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end }  -- FZF binary
  use 'ibhagwan/fzf-lua'  -- Lua wrapper with icon support

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

  -- Key mappings
    -- CTRL+p to search for files with icons
  vim.keymap.set('n', '<C-p>', '<cmd>FzfLua files<CR>', { desc = 'Find files' })

  -- Rg command for text search with icons
  vim.keymap.set('n', '<leader>rg', '<cmd>FzfLua live_grep<CR>', { desc = 'Live grep' })

  -- Git commit browser with fzf
  vim.keymap.set('n', '<leader>gco', '<cmd>FzfLua git_commits<CR>', { desc = 'Browse git commits' })
  vim.keymap.set('n', '<leader>gcs', '<cmd>FzfLua git_status<CR>', { desc = 'Git status' })
  vim.keymap.set('n', '<leader>gb', '<cmd>FzfLua git_branches<CR>', { desc = 'Git branches' })

    -- Git commit log mappings
    vim.keymap.set('n', '<leader>gl', '<cmd>Magit<CR>', { desc = 'Open Magit (Git interface)' })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end

  -- auto reload config.lua on save and run PackerCompile
  cmd([[
    augroup packer_user_config
      autocmd!
      autocmd BufWritePost config.lua source <afile> | PackerCompile
    augroup end
  ]])
end)
