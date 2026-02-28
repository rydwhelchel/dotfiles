-- =============================================================================
-- Telescope Configuration
-- =============================================================================
--
-- Telescope is a highly extensible fuzzy finder for Neovim.
--
-- DESIGN DECISIONS:
--
-- 1. Native FZF extension
--    We use telescope-fzf-native for faster fuzzy matching. It requires
--    a build step (make) but provides significantly better performance.
--
-- 2. UI-Select integration
--    telescope-ui-select makes Neovim's vim.ui.select use Telescope,
--    providing a consistent UI for code actions, etc.
--
-- 3. Keymap organization
--    - <leader>s* for search operations
--    - <leader>f* for file/buffer operations
--    - <leader><leader> for quick buffer switching
--
-- 4. C-j/C-k navigation
--    Following common convention (LazyVim, Omarchy), we use C-j/C-k for
--    moving through results instead of the default C-n/C-p (which we
--    repurpose for history navigation).
--
-- =============================================================================

return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- FZF native extension for better performance
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      -- Use Telescope for vim.ui.select
      { "nvim-telescope/telescope-ui-select.nvim" },
      -- File icons (requires Nerd Font)
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },

    config = function()
      local actions = require("telescope.actions")

      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              -- C-j/C-k for navigation (common convention)
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              -- C-n/C-p for history navigation
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
            },
          },
          path_display = { "truncate" },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Load extensions
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      -- Keymaps
      local builtin = require("telescope.builtin")

      -- File/Buffer operations (<leader>f*)
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecent" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })

      -- Search operations (<leader>s*)
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files" })

      -- Quick buffer switching
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find existing buffers" })

      -- Current buffer fuzzy find
      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- Search in open files
      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[S]earch [/] in Open Files" })

      -- Search Neovim config files
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })
    end,
  },
}
