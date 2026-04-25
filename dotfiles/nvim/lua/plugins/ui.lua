return {
  -- Rendered markdown (inline preview)
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  -- Markdown browser preview (Mermaid support)
  {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' },
    build = function() vim.fn['mkdp#util#install']() end,
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
  },

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

  -- Indent guides (via snacks.nvim)

  -- Snacks.nvim (explorer + utilities)
  {
    "folke/snacks.nvim",
    config = function(_, opts)
      require("snacks").setup(opts)

      -- Window-aware overrides for <C-h/j/k/l> and <CR>: if the current
      -- window is a snacks picker preview, do picker actions; otherwise
      -- fall through to tmux-navigator. Avoids buffer-local keymap leakage
      -- onto real file buffers (snacks reuses them for previews).
      local function active_preview_picker()
        local pickers = require("snacks").picker.get()
        if not pickers then return nil end
        local cur_win = vim.api.nvim_get_current_win()
        for _, p in ipairs(pickers) do
          if p.preview and p.preview.win and p.preview.win.win == cur_win then
            return p
          end
        end
        return nil
      end

      vim.keymap.set("n", "<C-h>", function()
        local p = active_preview_picker()
        if p then
          p:focus("input", { show = true })
        else
          vim.cmd("TmuxNavigateLeft")
        end
      end, { silent = true, desc = "Picker focus input / tmux left" })

      vim.keymap.set("n", "<C-l>", function()
        if active_preview_picker() then return end
        vim.cmd("TmuxNavigateRight")
      end, { silent = true, desc = "tmux right (no-op in preview)" })

      vim.keymap.set("n", "<C-j>", function()
        if active_preview_picker() then return end
        vim.cmd("TmuxNavigateDown")
      end, { silent = true, desc = "tmux down (no-op in preview)" })

      vim.keymap.set("n", "<C-k>", function()
        if active_preview_picker() then return end
        vim.cmd("TmuxNavigateUp")
      end, { silent = true, desc = "tmux up (no-op in preview)" })

      vim.keymap.set("n", "<CR>", function()
        local p = active_preview_picker()
        if not p then
          return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
        end
        local item = p:current()
        if not item then return end
        if item.commit then return end
        local pos = vim.api.nvim_win_get_cursor(0)
        item.pos = { pos[1], pos[2] }
        p:action("confirm")
      end, { silent = true, desc = "Picker jump to preview line / default <CR>" })
    end,
    opts = {
      statuscolumn = { enabled = true },
      zen = {
        show = {
          statusline = true,
          tabline = false,
        },
      },
      explorer = {
        replace_netrw = true,
      },
      indent = {
        indent = {
          hl = {
            "SnacksIndent1",
            "SnacksIndent2",
            "SnacksIndent3",
            "SnacksIndent4",
            "SnacksIndent5",
            "SnacksIndent6",
            "SnacksIndent7",
            "SnacksIndent8",
          },
        },
      },
      picker = {
        ui_select = true,
        previewers = {
          git = {
            args = { "-c", "diff.ignoreAllSpace=true" },
          },
        },
        actions = {
          jump_to_preview_line = function(picker)
            local item = picker:current()
            if not item then return end
            -- Don't run confirm for commit items — it would git_checkout/detach.
            if item.commit then return end
            local pos = vim.api.nvim_win_get_cursor(0)
            item.pos = { pos[1], pos[2] }
            picker:action("confirm")
          end,
        },
        win = {
          input = {
            keys = {
              ["<c-g>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-l>"] = { "focus_preview", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<c-g>"] = "preview_scroll_up",
              ["<c-l>"] = "focus_preview",
            },
          },
          preview = {
            keys = {},
          },
        },
        sources = {
          explorer = {
            layout = {
              preset = "sidebar",
              preview = false,
              layout = {
                position = "right",
                width = 35,
              },
            },
            hidden = true,
            ignored = true,
            auto_close = false,
            follow_file = true,
            watch = true,
            win = {
              input = {
                keys = {
                  ["<Esc>"] = { function() end, desc = "noop (don't close explorer)" },
                },
              },
              list = {
                keys = {
                  ["<Esc>"] = { function() end, desc = "noop (don't close explorer)" },
                  ["<leader>ghf"] = {
                    function()
                      local pickers = Snacks.picker.get({ source = "explorer" })
                      local item = pickers[1] and pickers[1]:current()
                      if item and item.file and not item.dir then
                        local cwd = vim.fn.fnamemodify(item.file, ":h")
                        local rel = vim.fn.system("git -C " .. vim.fn.shellescape(cwd) .. " ls-files --full-name " .. vim.fn.shellescape(item.file)):gsub("%s+$", "")
                        local branch = vim.fn.system("git -C " .. vim.fn.shellescape(cwd) .. " rev-parse --abbrev-ref HEAD"):gsub("%s+$", "")
                        local remote = vim.fn.system("git -C " .. vim.fn.shellescape(cwd) .. " config --get remote.origin.url"):gsub("%s+$", ""):gsub("^git@github.com:", "https://github.com/"):gsub("%.git$", "")
                        local url = remote .. "/blob/" .. branch .. "/" .. rel
                        vim.fn.setreg('+', url)
                        vim.notify("Copied: " .. url)
                      end
                    end,
                    desc = "Copy GitHub file URL",
                  },
                  ["<leader>ghp"] = {
                    function()
                      local pickers = Snacks.picker.get({ source = "explorer" })
                      local item = pickers[1] and pickers[1]:current()
                      if item and item.file and not item.dir then
                        local cwd = vim.fn.fnamemodify(item.file, ":h")
                        local rel = vim.fn.system("git -C " .. vim.fn.shellescape(cwd) .. " ls-files --full-name " .. vim.fn.shellescape(item.file)):gsub("%s+$", "")
                        local commit = vim.fn.system("git -C " .. vim.fn.shellescape(cwd) .. " log -n 1 --pretty=format:%H -- " .. vim.fn.shellescape(item.file)):gsub("%s+$", "")
                        local remote = vim.fn.system("git -C " .. vim.fn.shellescape(cwd) .. " config --get remote.origin.url"):gsub("%s+$", ""):gsub("^git@github.com:", "https://github.com/"):gsub("%.git$", "")
                        local url = remote .. "/blob/" .. commit .. "/" .. rel
                        vim.fn.setreg('+', url)
                        vim.notify("Copied: " .. url)
                      end
                    end,
                    desc = "Copy GitHub permalink",
                  },
                },
              },
            },
          },
        },
      },
    },
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
