return {
  -- Treesitter plugin definition
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "typescript", "javascript", "tsx", "json", "html", "css", "lua", "dockerfile", "bash", "yaml", "markdown", "markdown_inline", "gitcommit", "git_rebase", "gitattributes", "gitignore" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end
  }
}
