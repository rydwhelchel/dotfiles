return {
  -- NOTE: Enables the icon picker menu
  {
    "ziontee113/icon-picker.nvim",
    config = function()
      require("icon-picker").setup({ disable_legacy_commands = true })

      local opts = { noremap = true, silent = true }

      vim.keymap.set("n", "<Leader>si", "<cmd>IconPickerNormal<cr>", opts)
      vim.keymap.set("n", "<Leader>sy", "<cmd>IconPickerYank<cr>", opts) --> Yank the selected icon into register
      vim.keymap.set("i", "<C-i>", "<cmd>IconPickerInsert<cr>", opts)
    end,
  },

  -- NOTE: Overrides the icon shown in neotree for given extensions
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      strict = true,
      override_by_extension = {
        ["gleam"] = {
          icon = "󰦥",
          color = "#FFAFF3",
          name = "Gleam",
        },
      },
    },
  },
}
