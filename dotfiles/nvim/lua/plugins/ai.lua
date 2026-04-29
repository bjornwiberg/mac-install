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
          keys = {
            nav_left  = false,
            nav_down  = false,
            nav_up    = false,
            nav_right = false,
          },
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
      {
        "<leader>ao",
        function()
          local models = vim.fn.systemlist("ollama list 2>/dev/null | tail -n +2 | awk '{print $1}'")
          if vim.v.shell_error ~= 0 or #models == 0 then
            vim.notify("No Ollama models found. Try `ollama pull <model>`.", vim.log.levels.WARN)
            return
          end
          vim.ui.select(models, { prompt = "ollama launch claude --model:" }, function(choice)
            if not choice then return end
            -- tmux session names can't contain ':' (it's `session:window` syntax),
            -- so sanitize for the sidekick tool/session name. Model arg keeps `:`.
            local name = "ollama-" .. choice:gsub("[:/]", "-")
            local Config = require("sidekick.config")
            Config.cli.tools = Config.cli.tools or {}
            Config.cli.tools[name] = {
              cmd = { "ollama", "launch", "claude", "--model", choice, "--yes" },
            }
            require("sidekick.cli").toggle({ name = name, focus = true })
          end)
        end,
        desc = "Sidekick: ollama launch claude (model picker)",
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
