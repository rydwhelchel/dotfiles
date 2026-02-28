-- =============================================================================
-- Plugin Loading Configuration
-- =============================================================================
--
-- This file configures lazy.nvim to load plugins from the lua/plugins/
-- directory. Each file in that directory returns a table of plugin specs.
--
-- DESIGN DECISIONS:
--
-- 1. Single import directory
--    All plugins are in lua/plugins/ for simplicity. No kickstart/custom
--    split - everything is in one place.
--
-- 2. ASCII icons fallback
--    When Nerd Fonts aren't available, we use simple ASCII characters
--    instead of emoji for better terminal compatibility.
--
-- =============================================================================

require("lazy").setup({
  -- Import all plugin specs from lua/plugins/
  { import = "plugins" },
}, {
  -- Performance settings
  performance = {
    -- Don't reset packpath - preserves Nix-installed plugins
    -- (e.g., nvim-treesitter.withAllGrammars from home-manager)
    reset_packpath = false,
  },
  ui = {
    -- Use ASCII icons when Nerd Fonts aren't available
    icons = vim.g.have_nerd_font and {} or {
      cmd = "!",
      config = "cfg",
      event = "E",
      ft = "ft",
      init = "I",
      keys = "K",
      plugin = "+",
      runtime = "RT",
      require = "req",
      source = "src",
      start = ">",
      task = "T",
      lazy = "z",
    },
  },
})
