return function(use)
  -- Theme and UI plugin definitions
  use 'ellisonleao/gruvbox.nvim'

  -- File explorer
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'

  -- Scrollbar plugin
  use("petertriho/nvim-scrollbar")
  require("scrollbar").setup()

  -- Tab bar plugin
  use {
    'romgrk/barbar.nvim',
    requires = {'nvim-tree/nvim-web-devicons'}
  }

  -- Status line
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }

  -- Indent guides
  use "lukas-reineke/indent-blankline.nvim"

  -- Neo-tree file explorer
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim"
    },
  }

  -- FZF with icons using fzf-lua (better icon support)
  use { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end }  -- FZF binary
  use 'ibhagwan/fzf-lua'  -- Lua wrapper with icon support

  -- Other UI plugins
  use 'ryanoasis/vim-devicons'
  use 'edkolev/tmuxline.vim'
  use 'frazrepo/vim-rainbow'
  use("petertriho/nvim-scrollbar")

  -- UI Plugin Configurations
  -- Setup theme
  vim.cmd[[colorscheme gruvbox]]

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
          ["<S-down>"]    = "preview-page-down",
          ["<S-up>"]      = "preview-page-up",
        },
        fzf = {
          ["ctrl-u"] = "half-page-up",
          ["ctrl-d"] = "half-page-down",
          ["shift-down"]  = "preview-page-down",
          ["shift-up"]    = "preview-page-up",
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
end
