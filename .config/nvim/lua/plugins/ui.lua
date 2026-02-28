-- =============================================================================
-- UI Configuration
-- =============================================================================
--
-- This file configures UI enhancements: dashboard, notifications, command
-- palette, terminal, and keybinding hints.
--
-- DESIGN DECISIONS:
--
-- 1. Snacks.nvim as the UI foundation
--    Snacks provides a collection of small UI utilities that work well
--    together. We enable only the modules we use to keep things lean.
--
-- 2. Noice for command line UI
--    Noice replaces the command line with a floating window and provides
--    better notification handling. It also improves LSP UI elements.
--
-- 3. Single which-key instance
--    We consolidate which-key configuration here instead of having it in
--    multiple places. This prevents conflicts and duplicate registrations.
--
-- 4. Group prefixes
--    All leader key groups are defined in which-key's spec to provide
--    consistent hints across the configuration.
--
-- =============================================================================

return {
	-- ---------------------------------------------------------------------------
	-- Snacks.nvim: Collection of small UI utilities
	-- ---------------------------------------------------------------------------
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			-- Large file handling (disable slow features for big files)
			bigfile = { enabled = true },

			-- Dashboard on startup
			dashboard = {
				enabled = true,
				preset = {
					header = [[
   Neovim
   (NixOS Edition)
          ]],
				},
			},

			-- Git browse (open in GitHub/GitLab)
			gitbrowse = { enabled = true },

			-- Indent guides
			indent = { enabled = true },

			-- Better vim.ui.input
			input = { enabled = true },

			-- Notification system
			notifier = { enabled = true },

			-- Quick file opening
			quickfile = { enabled = true },

			-- Scope detection and navigation
			scope = { enabled = true },

			-- Smooth scrolling
			scroll = {
				enabled = true,
				animate = {
					duration = {
						step = 3,
						total = 100,
					},
				},

				-- I don't even feel a difference with this but I like it in concept
				animate_repeat = {
					delay = 100,
					duration = { step = 1, total = 50 },
					easing = "linear",
				},
			},

			-- Status column (signs, line numbers, fold)
			statuscolumn = { enabled = true },

			-- Word highlighting under cursor
			words = { enabled = true },

			-- Zen mode -- idk if I really like this
			zen = { enabled = false },

			-- Floating terminal
			terminal = {
				win = { style = "float" },
			},
		},

		config = function(_, opts)
			local Snacks = require("snacks")
			Snacks.setup(opts)

			-- Toggle keymaps with notifications
			-- Note: <leader>th (inlay hints) already in lsp.lua
			-- Note: <leader>tb (git blame) already in git.lua
			Snacks.toggle.option("spell", { name = "Spell" }):map("<leader>ts")
			Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
			Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tr")
			Snacks.toggle.diagnostics():map("<leader>td")
			Snacks.toggle.treesitter():map("<leader>tT")
		end,

		keys = {
			{
				"<leader>ft",
				function()
					Snacks.terminal()
				end,
				desc = "[F]loating [T]erminal",
			},
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "[B]uffer [D]elete",
			},
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"gb",
				function()
					Snacks.gitbrowse()
				end,
				desc = "[G]it [B]rowse",
				mode = { "n", "v" },
			},
			{
				"<leader>zen",
				function()
					Snacks.zen()
				end,
				desc = "Zen Mode",
			},
		},
	},

	-- ---------------------------------------------------------------------------
	-- Noice: Command line and notification UI
	-- ---------------------------------------------------------------------------
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					-- Note: cmp.entry.get_documentation removed (we use blink.cmp)
				},
			},
			presets = {
				bottom_search = true, -- Search appears at bottom
				command_palette = true, -- Command line as floating window
				long_message_to_split = true, -- Long messages go to split
			},
		},
	},

	-- ---------------------------------------------------------------------------
	-- Which-Key: Keybinding hints
	-- ---------------------------------------------------------------------------
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-...> ",
					M = "<M-...> ",
					D = "<D-...> ",
					S = "<S-...> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
				},
			},

			-- Define all leader key group prefixes
			spec = {
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code" },
				{ "<leader>d", group = "document" },
				{ "<leader>f", group = "file/find" },
				{ "<leader>g", group = "git" },
				{ "<leader>h", group = "git hunk", mode = { "n", "v" } },
				{ "<leader>s", group = "search" },
				{ "<leader>t", group = "toggle" },
				{ "<leader>u", group = "ui" },
				{ "<leader>w", group = "workspace" },
			},
		},
	},
}
