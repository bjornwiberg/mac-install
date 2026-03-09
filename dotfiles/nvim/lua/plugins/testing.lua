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
      -- On macOS, /Users is a symlink to /private/Users. vitest resolves paths
      -- internally via realpathSync, so the filter "/Users/..." never matches
      -- the discovered "/private/Users/..." paths → "No tests found".
      -- Fix: resolve the file path in the vitest command before it runs.
      local vitest = require('neotest-vitest')
      local vitest_adapter = vitest({
        filter_dir = function(name)
          return name ~= 'node_modules' and name ~= 'playwright'
        end,
      })
      -- build_spec: pass the real path so vitest can find the file.
      local orig_build_spec = vitest_adapter.build_spec
      vitest_adapter.build_spec = function(args)
        local spec = orig_build_spec(args)
        if spec and spec.command then
          local last = spec.command[#spec.command]
          if last and not last:match('^%-') then
            spec.command[#spec.command] = vim.fn.resolve(last)
          end
        end
        return spec
      end

      -- results: vitest reports results keyed with the real path (/private/Users/...),
      -- but neotest positions are stored with the symlinked path (/Users/...).
      -- Re-map result keys back to symlinked paths so signs update correctly.
      local orig_results = vitest_adapter.results
      vitest_adapter.results = function(spec, b, tree)
        local test_results = orig_results(spec, b, tree)
        local symlinked_file = spec.context and spec.context.file
        if symlinked_file then
          local real_file = vim.fn.resolve(symlinked_file)
          if real_file ~= symlinked_file then
            local fixed = {}
            for key, result in pairs(test_results) do
              fixed[key:gsub(vim.pesc(real_file), symlinked_file, 1)] = result
            end
            return fixed
          end
        end
        return test_results
      end

      -- Playwright: rootDir in playwright's JSON report is always the real path.
      -- Wrap discover_positions to store positions with real paths so they match
      -- the real paths playwright uses when building result keys.
      local pw_adapter = require('neotest-playwright').adapter({
        options = {
          persist_project_selection = true,
          enable_dynamic_test_discovery = true,
        },
      })
      local orig_discover_pw = pw_adapter.discover_positions
      pw_adapter.discover_positions = function(path)
        return orig_discover_pw(vim.fn.resolve(path))
      end

      local c = require('tokyonight.colors').setup({ style = 'night' })
      vim.api.nvim_set_hl(0, 'NeotestOutputPanel', { bg = c.bg_dark })

      require('neotest').setup({
        discovery = {
          enabled = true,
        },
        diagnostic = {
          enabled = false,
        },
        status = {
          signs = true,
          virtual_text = false,
        },
        output = {
          enabled = true,
          open_on_run = false,
        },
        output_panel = {
          enabled = true,
          open_on_run = false,
        },
        floating = {
          border = 'rounded',
          max_height = 0.6,
          max_width = 0.6,
        },
        adapters = {
          vitest_adapter,
          pw_adapter,
        },
      })
    end,
  },
}
