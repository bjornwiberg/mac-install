return function(use)
  -- Treesitter plugin definition
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
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
    end
  }
end
