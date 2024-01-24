vim.o.runtimepath = vim.fn.stdpath('data') .. '/site/pack/*/start/*,' .. vim.o.runtimepath

local fn = vim.fn
local cmd = vim.cmd
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
  vim.opt.termguicolors = true

  -- My plugins here
  -- fade inactive windows
  use 'TaDaa/vimade'
  -- theme
  use 'folke/tokyonight.nvim'
  use 'ellisonleao/gruvbox.nvim'
  use 'tomasiser/vim-code-dark'
  vim.g.tokyonight_italic_functions = true
  vim.cmd[[colorscheme gruvbox]]

  use("petertriho/nvim-scrollbar")

  -- color indent
  use "lukas-reineke/indent-blankline.nvim"
  cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
  cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
  cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
  cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
  cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
  cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]
  require("indent_blankline").setup {
      char_highlight_list = {
          "IndentBlanklineIndent1",
          "IndentBlanklineIndent2",
          "IndentBlanklineIndent3",
          "IndentBlanklineIndent4",
          "IndentBlanklineIndent5",
          "IndentBlanklineIndent6",
      },
  }

  -- tab bar plugin
  use {
    'romgrk/barbar.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  }
  vim.g.bufferline = {
    -- Enable/disable close button
    closable = false,
  }

  -- file explorer
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
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
          },
          follow_current_file = true, -- This will find and focus the file in the active buffer every
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
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  require'nvim-treesitter.configs'.setup {
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    }
  }

  use {
  'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  require('lualine').setup {
    theme = 'gruvbox',
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
  use 'OmniSharp/omnisharp-vim'
  use 'frazrepo/vim-rainbow'
  use 'blueyed/vim-diminactive'

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

