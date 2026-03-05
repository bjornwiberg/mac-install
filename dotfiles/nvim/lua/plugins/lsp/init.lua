return {
  -- LSP plugin definitions
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- Global LSP settings
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
        focusable = false,
        stylize_markdown = true,
      })

      vim.opt.completeopt = { "menuone", "noselect", "popup" }
      vim.opt.updatetime = 350  -- 350ms (0.35 seconds)

      -- Auto-show diagnostic float or LSP hover on cursor hold
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
          if #diagnostics > 0 then
            vim.diagnostic.open_float(nil, {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter" },
            })
          else
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            local has_hover = vim.iter(clients):any(function(c)
              return c.supports_method("textDocument/hover")
            end)
            if has_hover then
              vim.lsp.buf.hover()
            end
          end
        end,
      })

      -- Per-server LSP configs
      require('plugins.lsp.ts')
      require('plugins.lsp.biome')
      -- Add more servers as needed, e.g.:
      -- require('plugins.lsp.lua_ls')
    end,
  },

  -- LSP Autocompletion plugin definitions
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
    },
    config = function()
      -- LSP Autocompletion configuration
      local cmp = require'cmp'
      local luasnip = require'luasnip'
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' },
        },
      })
    end,
  },
}
