return {
  {
    'github/copilot.vim',
    config = function()
      local function set_hl()
        local ok, palette = pcall(require, 'tokyonight.colors')
        local c = ok and palette.setup({ style = 'night' }) or {}
        vim.api.nvim_set_hl(0, 'CopilotSuggestion', {
          fg = c.comment or '#565f89',
          italic = true,
          force = true,
        })
      end
      set_hl()
      vim.api.nvim_create_autocmd('ColorScheme', { callback = set_hl })
    end,
  },
  {
    "folke/sidekick.nvim",
    event = "VeryLazy",
    opts = {
      cli = {
        win = {
          layout = "left",
        },
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>"
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<c-.>",
        function() require("sidekick.cli").focus() end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
    },
  },
}

--[[
-- Original claudecode setup (re-enable by removing this block comment and
-- removing the return above):
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = function()
      require("claudecode").setup({
        terminal = {
          provider = "snacks",
          split_side = "left",
        },
      })
    end,
  },
}
--]]
