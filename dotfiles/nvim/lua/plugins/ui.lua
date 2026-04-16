return {
  -- Color schemes
  {
    'folke/tokyonight.nvim',
    --
    priority = 1000,
    config = function()
      vim.cmd("colorscheme tokyonight-night")
    end,
  },

  -- Icons (mini.icons replaces nvim-web-devicons for fzf-lua glob support)
  {
    'echasnovski/mini.icons',
    version = false,
    config = function()
      require('mini.icons').setup()
      -- Make fzf-lua and other plugins that use nvim-web-devicons API use mini.icons
      require('mini.icons').mock_nvim_web_devicons()
    end,
  },

  -- File explorer
  { 'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup({
        sort_by = "case_sensitive",
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
      })
    end,
  },
  { 'nvim-tree/nvim-web-devicons' },

  -- Scrollbar plugin
  {
    "petertriho/nvim-scrollbar",
    config = function()
      require("scrollbar").setup()
    end,
  },

  -- Tab bar plugin
  {
    'romgrk/barbar.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      }
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      local highlight = {
        "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
        "RainbowGreen", "RainbowViolet", "RainbowCyan",
      }

      local hooks = require "ibl.hooks"

      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed",    { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = "#56B6C2" })
      end)

      require('ibl').setup { indent = { highlight = highlight } }
    end,
  },

  -- Neo-tree file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require('neo-tree').setup({
        filesystem = {
          filtered_items = {
            visible = true, -- when true, they will just be displayed differently than normal items
            never_show = { -- remains hidden even if visible is toggled to true
              ".DS_Store",
            },
          },
          use_libuv_file_watcher = true, -- does not need to be manually refreshed
          follow_current_file = {
            enabled = true, -- intelligently follow the current file
          },
        },
        commands = {
          github_permalink = function(state)
            local node = state.tree:get_node()
            if node and _G._github_file_url then
              _G._github_file_url(node:get_id(), true)
            end
          end,
          github_branch_url = function(state)
            local node = state.tree:get_node()
            if node and _G._github_file_url then
              _G._github_file_url(node:get_id(), false)
            end
          end,
        },
        window = {
          mappings = {
            ["ghp"] = "github_permalink",
            ["ghu"] = "github_branch_url",
          },
        },
      })
    end,
  },

  -- FZF with icons using fzf-lua (better icon support)
  { 'junegunn/fzf', build = function() vim.fn['fzf#install']() end },  -- FZF binary
  {
    'ibhagwan/fzf-lua',  -- Lua wrapper with icon support
    config = function()
      require('fzf-lua').setup({
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
            ["<S-down>"] = "preview-page-down",
            ["<S-up>"]   = "preview-page-up",
            ["<C-g>"] = "preview-page-down",
            ["<C-f>"]   = "preview-page-up",
          },
          fzf = {
            ["ctrl-u"]     = "half-page-up",
            ["ctrl-d"]     = "half-page-down",
            ["shift-down"] = "preview-page-down",
            ["shift-up"]   = "preview-page-up",
            ["ctrl-g"]     = "preview-page-down",
            ["ctrl-f"]     = "preview-page-up",
          },
        },
        files = {
          prompt = 'Files❯ ',
          multiprocess = true,
          git_icons = true,
          file_icons = true,
          color_icons = true,
          cmd = 'rg --files --hidden --no-ignore-vcs --ignore-file ~/.config/nvim/.rgignore',
          previewer = 'builtin',
        },
        grep = {
          prompt = 'Rg❯ ',
          input_prompt = 'Grep For❯ ',
          multiprocess = true,
          git_icons = true,
          file_icons = true,
          color_icons = true,
          cmd = 'rg --color=always --column --hidden -n --no-heading -S --no-ignore-vcs --ignore-file ~/.config/nvim/.rgignore',
          previewer = 'builtin',
        },
        -- Disable find command usage to avoid macOS compatibility issues
        find = {
          cmd = 'rg --files --hidden --no-ignore-vcs --ignore-file ~/.config/nvim/.rgignore',
        },
        -- Ensure LSP operations work properly
        lsp = {
          code_actions    = { previewer = 'builtin' },
          implementations = { previewer = 'builtin' },
          references      = { previewer = 'builtin' },
          definitions     = { previewer = 'builtin' },
        },
      })
    end,
  },

  -- Notification system
  {
    'rcarriga/nvim-notify',
    config = function()
      local c = require('tokyonight.colors').setup({ style = 'night' })
      require('notify').setup({
        background_colour = c.bg_dark,
        render = 'wrapped-compact',
        stages = 'fade',
        timeout = 3000,
      })
      vim.notify = require('notify')
    end,
  },

  -- Noice: unified UI for cmdline, messages, LSP hover, signature help, diagnostics
  {
    'folke/noice.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup({
        lsp = {
          -- Let noice handle hover and signature help
          hover    = { enabled = true },
          signature = { enabled = true },
          -- Override markdown rendering so cmp + other plugins use Treesitter
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        cmdline = {
          view = 'cmdline_popup',
        },
        views = {
          cmdline_popup = {
            position = { row = '35%', col = '50%' },
            size = { width = 60, height = 'auto' },
          },
          popupmenu = {
            relative = 'editor',
            position = { row = '45%', col = '50%' },
            size = { width = 60, height = 10 },
            border = { style = 'rounded', padding = { 0, 1 } },
          },
        },
        presets = {
          bottom_search        = true,   -- classic bottom cmdline for search
          command_palette      = false,  -- we manage positions manually
          long_message_to_split = true,  -- long messages go to a split
          lsp_doc_border       = true,   -- border on hover/signature docs
        },
      })
    end,
  },

  -- Other UI plugins
  { 'ryanoasis/vim-devicons' },
  { 'edkolev/tmuxline.vim' },
  { 'frazrepo/vim-rainbow' },
}
