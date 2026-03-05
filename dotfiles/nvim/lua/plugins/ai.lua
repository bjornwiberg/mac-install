return function(use)
  use({
    "coder/claudecode.nvim",
    requires = {
      { "folke/snacks.nvim" },
    },
    config = function()
      require("claudecode").setup({
        terminal = {
          split_side = "left", -- "left" or "right"
        },
      })
    end,
  })
end
