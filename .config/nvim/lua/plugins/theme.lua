-- =============================================================================
-- Theme Configuration
-- =============================================================================

return {
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	priority = 1000, -- Load before other plugins
	-- 	config = function()
	-- 		require("tokyonight").setup()
	--
	-- 		-- Apply the colorscheme
	-- 		-- Other variants: 'tokyonight-storm', 'tokyonight-moon', 'tokyonight-day'
	-- 		vim.cmd.colorscheme("tokyonight-night")
	-- 	end,
	--  }
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup()
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
}
