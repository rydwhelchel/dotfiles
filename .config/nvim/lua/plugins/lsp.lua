return {
  -- LSP Configuration & Plugins
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gleam = { mason = false },
    },
  },
  -- setup = {
  --   tailwindcss = function(_, opts)
  --     local tw = require("lspconfig.server_configurations.tailwindcss")
  --     opts.filetypes = opts.filetypes or {}
  --
  --     -- Add default filetypes
  --     vim.list_extend(opts.filetypes, tw.default_config.filetypes)
  --
  --     -- Remove excluded filetypes
  --     --- @param ft string
  --     opts.filetypes = vim.tbl_filter(function(ft)
  --       return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
  --     end, opts.filetypes)
  --
  --     -- Add additional filetypes
  --     vim.list_extend(opts.filetypes, opts.filetypes_include or {})
  --   end,
  -- },
  -- tailwind = {
  --   filetypes = {
  --     "astro",
  --     "eex",
  --     "eruby",
  --     "handlebars",
  --     "heex",
  --     "html",
  --     "javascript",
  --     "javascriptreact",
  --     "svelte",
  --     "templ",
  --     "typescript",
  --     "typescriptreact",
  --   },
  --   init_options = {
  --     userLanguages = { templ = "html", eruby = "html", heex = "html", eex = "html" },
  --   },
  -- },
}
