-- Plugin management with Packer (official bootstrap pattern)
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  -- LSP and related plugins
  use {
    'neovim/nvim-lspconfig',
    config = function()
      require('lsp')
    end
  }
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

  -- Prettier for proper formatting with import sorting
  use 'prettier/vim-prettier'

  -- File explorer
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'

  -- Git integration
  use 'tpope/vim-fugitive'
  use 'TimUntersberger/neogit'

  -- Editor enhancements
  use 'editorconfig/editorconfig-vim'

  -- Theme and UI
  use 'ellisonleao/gruvbox.nvim'

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

  -- Commenting
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  -- Other useful plugins
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

  -- GitHub Copilot
  use 'github/copilot.vim'

  -- Which-key for keybinding help
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {}
    end
  }

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

  if packer_bootstrap then
    require('packer').sync()
  end
end)
