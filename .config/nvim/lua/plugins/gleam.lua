-- NOTE: This is a holdout until the PR is merged which will include GLEAM as an extra for LazyVim

return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        gleam = { mason = false },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "gleam",
      })
    end,
  },
}
