-- =============================================================================
-- Treesitter Configuration
-- =============================================================================
--
-- DESIGN DECISIONS:
--
-- 1. NixOS: Plugin + parsers installed via Nix
--    home-manager installs nvim-treesitter.withAllGrammars which provides
--    both the plugin AND all parsers. The new nvim-treesitter uses Neovim's
--    built-in treesitter API, so we enable highlighting via vim.treesitter.
--
-- 2. Non-NixOS: Install via lazy.nvim (uses older API with configs.setup)
--
-- =============================================================================

local is_nixos = vim.fn.filereadable("/etc/NIXOS") == 1

if is_nixos then
  -- On NixOS: Parsers come from Nix, use Neovim's built-in treesitter
  -- The new nvim-treesitter doesn't have configs.setup() anymore

  -- Enable treesitter highlighting for all filetypes with available parsers
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      -- Try to start treesitter highlighting for this buffer
      pcall(vim.treesitter.start, args.buf)
    end,
  })

  -- Enable treesitter-based indentation
  vim.opt.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

  return {}
end

-- Non-NixOS: Install treesitter via lazy.nvim (older API still works)
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if ok then
        configs.setup({
          ensure_installed = {
            "bash", "c", "diff", "html", "lua", "luadoc",
            "markdown", "markdown_inline", "query", "vim", "vimdoc",
            "go", "rust", "python", "typescript", "javascript",
            "elixir", "heex", "eex", "nix", "zig", "elm", "ruby",
            "astro", "css",
          },
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
        })
      end
    end,
  },
}
