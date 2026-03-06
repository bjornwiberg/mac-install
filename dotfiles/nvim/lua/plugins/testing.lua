return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'marilari88/neotest-vitest',
      'thenbe/neotest-playwright',
    },
    config = function()
      require('neotest').setup({
        status = {
          signs = true,
          virtual_text = false,
        },
        adapters = {
          require('neotest-vitest')({
            filter_dir = function(name)
              return name ~= 'node_modules' and name ~= 'playwright'
            end,
          }),
          require('neotest-playwright').adapter({
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
            },
          }),
        },
      })
    end,
  },
}
