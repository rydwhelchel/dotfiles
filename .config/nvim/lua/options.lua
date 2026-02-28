local opt = vim.opt

-- Make line numbers default
opt.number = true
-- opt.relativenumber = true

-- Controls how many lines from the "edge" of the screen you will be
opt.scrolloff = 10
opt.sidescrolloff = 8

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Enables 24-bit colors in TUI
opt.termguicolors = true

-- Enable mouse mode, can be useful for resizing splits for example!
opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
-- Do these two inc settings work together?
opt.incsearch = true
opt.inccommand = 'split'

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Keep signcolumn on by default
opt.signcolumn = "yes"

-- Decrease update time
opt.updatetime = 250 -- Faster completion and diagnostic hover

-- Decrease mapped sequence wait time
opt.timeoutlen = 300 -- Faster key sequence completion (WhichKey)

-- TODO: What is this?
opt.completeopt = "menu,menuone,noselect"

-- Configure how new splits should be opened
opt.splitbelow = true
opt.splitright = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!

-- Show which line your cursor is on
opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
opt.confirm = true -- Confirm to save changes before exiting modified buffer
-- Disable swap files (I never make use of these and they're annoying when they get puked into my directory)
opt.swapfile = false
