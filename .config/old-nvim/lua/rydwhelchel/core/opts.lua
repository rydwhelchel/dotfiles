-- NOTE: See `:help vim.opt` & `:help option-list
local opt = vim.opt

-- [[ Tabs ]]
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.breakindent = true -- Maintain indent on wrapping lines

opt.ignorecase = true  -- Case-insensitive searching
opt.smartcase = true   -- UNLESS \C or one or more capital letters in search

opt.cursorline = true  -- Show which line your cursor is on
opt.signcolumn = 'yes' -- Keep signcolumn on by default

-- [[ Themeage ]]
opt.termguicolors = true -- True terminal colors
opt.background = 'dark'  -- defaults themes to their dark version
vim.g.have_nerd_font = true
opt.number = true        -- Make line numbers default

-- Configure how new splits should be opened
opt.splitright = true
opt.splitbelow = true

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

opt.mouse = 'a'      -- Enable mouse mode, can be useful for resizing splits for example!
opt.showmode = false -- Don't show the mode, since it's already in the status line
opt.undofile = true  -- Save undo history
opt.updatetime = 250 -- Decrease update time

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
opt.timeoutlen = 300

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
opt.list = true
-- opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
opt.inccommand = 'split'

-- Minimal number of screen lines to keep above and below the cursor.
opt.scrolloff = 10

-- [[ Graveyard ]]
-- opt.relativenumber = true -- Relative line numbers
