-- =============================================================================
-- Editor Enhancements
-- =============================================================================
--
-- This file configures general editor enhancements that improve the
-- editing experience across all filetypes.
--
-- DESIGN DECISIONS:
--
-- 1. Mini.nvim for text objects, surround, and autopairs
--    Mini.nvim provides lightweight, fast implementations of common features.
--    We use mini.ai for enhanced text objects, mini.surround for
--    surrounding operations, and mini.pairs for automatic bracket pairing.
--
-- 2. Mini.statusline
--    A simple, lightweight statusline that works out of the box.
--    Configured to show LINE:COLUMN in a compact format.
--
-- 3. Todo-comments for task tracking
--    Highlights TODO, FIXME, NOTE, etc. in comments and provides
--    navigation commands. Signs disabled to reduce visual clutter.
--
-- 4. Oil.nvim for file exploration
--    Edit directories like buffers. Rename, delete, and create files
--    by editing text in the buffer.
--
-- =============================================================================

return {
	-- ---------------------------------------------------------------------------
	-- Mini.nvim: Collection of small, focused modules
	-- ---------------------------------------------------------------------------
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		config = function()
			-- Enhanced text objects (around/inside)
			-- Examples:
			--   va)  - [V]isually select [A]round [)]paren
			--   yinq - [Y]ank [I]nside [N]ext [Q]uote
			--   ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Surround operations
			-- Examples:
			--   saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			--   sd'   - [S]urround [D]elete [']quotes
			--   sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			-- Autopairs: automatically close brackets, quotes, etc.
			-- Handles (), [], {}, '', "", ``
			require("mini.pairs").setup()

			-- Simple statusline
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })

			-- Custom section for cursor location: LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},

	-- ---------------------------------------------------------------------------
	-- Todo-comments: Highlight and navigate TODO comments
	-- ---------------------------------------------------------------------------
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- Disable signs to reduce visual noise
			signs = false,
		},
	},

	-- ---------------------------------------------------------------------------
	-- Oil.nvim: Edit directories like buffers
	-- ---------------------------------------------------------------------------
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				view_options = {
					show_hidden = true,
				},
				-- Keymaps in oil buffer
				keymaps = {
					["<Esc>"] = "actions.close",
				},
				-- Floating window configuration
				float = {
					padding = 2,
					max_width = 80,
					max_height = 30,
					border = "rounded",
					win_options = {
						winblend = 0,
					},
				},
			})
			-- Use toggle_float for floating window
			vim.keymap.set("n", "<leader>e", function()
				require("oil").toggle_float()
			end, { desc = "File [E]xplorer (Oil)" })
		end,
	},
}
