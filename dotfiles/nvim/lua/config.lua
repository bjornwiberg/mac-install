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

return require('packer').startup(function(use)
  vim.opt.termguicolors = true

  -- My plugins here
  -- theme
  use 'folke/tokyonight.nvim'
  use 'ellisonleao/gruvbox.nvim'
  use 'tomasiser/vim-code-dark'
  vim.g.tokyonight_italic_functions = true
  vim.cmd[[colorscheme gruvbox]]

  use("petertriho/nvim-scrollbar")

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


  -- tab bar plugin
  use {
    'romgrk/barbar.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  -- file explorer
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
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
            follow_current_file = true, -- This will find and focus the file in the active buffer every
          },
        },
      })

      vim.cmd([[nnoremap <C-a> :Neotree right toggle<cr>]])
      vim.cmd([[nnoremap <Leader>g :Neotree git_status float toggle<cr>]])
      vim.cmd([[nnoremap <Leader>b :Neotree buffers float toggle<cr>]])
    end
  }

  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
  }

  use 'JoosepAlviste/nvim-ts-context-commentstring'
  require('nvim-treesitter.configs').setup {}
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use {
  'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
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
  use 'editorconfig/editorconfig-vim'
  use 'tpope/vim-surround'
  use 'ryanoasis/vim-devicons'
  use 'edkolev/tmuxline.vim'
  use 'dhruvasagar/vim-zoom'
  use 'jreybert/vimagit'
  use 'puremourning/vimspector'
  use 'frazrepo/vim-rainbow'

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

