-- If on a Nix system, don't attempt to download LSPs & Treesitter grammars
if vim.env.IS_NIXOS == "true" then
  return {
    { "williamboman/mason.nvim",           enabled = false },
    { "williamboman/mason-lspconfig.nvim", enabled = false },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        -- 1. Disable auto-install (Nix handles this now)
        auto_install = false,

        -- 2. Leave ensure_installed empty or commented out
        -- (Nix already ensured they are installed)
        ensure_installed = {},

        highlight = { enable = true },
        indent = { enable = true },
      },
    },
  }
end
return {}
