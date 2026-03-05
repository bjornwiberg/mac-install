return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      require("claudecode").setup({
        terminal = {
          split_side = "left", -- "left" or "right"
        },
      })
    end,
  },
}
