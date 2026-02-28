-- =============================================================================
-- Completion Configuration (blink.cmp)
-- =============================================================================
--
-- This file configures autocompletion using blink.cmp.
--
-- DESIGN DECISIONS:
--
-- 1. blink.cmp over nvim-cmp
--    blink.cmp is a modern, faster completion engine with better defaults.
--    It integrates well with LSP and provides a smoother experience than
--    the older nvim-cmp ecosystem. Having both causes conflicts.
--
-- 2. LuaSnip for snippets
--    LuaSnip is a mature snippet engine with good performance and features.
--    We use it with blink.cmp's luasnip preset for seamless integration.
--
-- 3. Lua fuzzy matcher (not Rust)
--    While blink.cmp offers a Rust fuzzy matcher for better performance,
--    we use the Lua implementation for simplicity and to avoid binary
--    dependencies. The Lua version is fast enough for most use cases.
--
-- 4. Custom keymap with default preset base
--    We extend the 'default' preset with additional mappings:
--    - <C-j>/<C-k> for navigation (consistent with Telescope)
--    - <CR> to accept (in addition to <C-y>)
--    - <C-space> to open/toggle docs
--    The default preset's <C-n>/<C-p> navigation remains available.
--
-- =============================================================================

return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "1.*",
    dependencies = {
      -- Snippet engine
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          -- Build step for regex support in snippets
          -- Skipped on Windows where make isn't typically available
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        opts = {},
      },
      -- Lazydev integration for Neovim Lua API completion
      "folke/lazydev.nvim",
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- Keymap configuration
      -- Extends 'default' preset with C-j/C-k navigation and Enter to accept
      -- See :h blink-cmp-config-keymap for custom mappings
      keymap = {
        preset = "default",
        -- C-j/C-k for navigation (consistent with Telescope)
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        -- Enter to accept completion
        ["<CR>"] = { "accept", "fallback" },
      },

      -- Appearance settings
      appearance = {
        -- 'mono' for Nerd Font Mono, 'normal' for regular Nerd Font
        nerd_font_variant = "mono",
      },

      -- Completion behavior
      completion = {
        -- Documentation window settings
        -- Set auto_show = true to show docs automatically after delay
        documentation = {
          auto_show = false,
          auto_show_delay_ms = 500,
        },
      },

      -- Completion sources in priority order
      sources = {
        default = { "lsp", "path", "snippets", "lazydev" },
        providers = {
          -- Lazydev provides Neovim Lua API completions
          -- High score_offset ensures it appears first for Lua files
          lazydev = {
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },

      -- Snippet engine configuration
      snippets = {
        preset = "luasnip",
      },

      -- Fuzzy matching implementation
      -- 'lua' is simpler and avoids binary dependencies
      -- 'prefer_rust_with_warning' can be used for better performance
      fuzzy = {
        implementation = "lua",
      },

      -- Show signature help while typing function arguments
      signature = {
        enabled = true,
      },
    },
  },
}
