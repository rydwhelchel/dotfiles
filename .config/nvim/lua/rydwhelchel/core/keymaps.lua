-- [[ Basic Keymaps ]] See `:help vim.keymap.set()`
local keymap = vim.keymap

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- TODO: ?
keymap.set('c', 'W', 'w')

-- Clear highlights on search when pressing <Esc> in normal mode
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' }) --  See `:help hlsearch`

keymap.set('n', '<leader>+', '<C-a>', { desc = 'Increment number' })
keymap.set('n', '<leader>-', '<C-x>', { desc = 'Decrement number' })

-- NOTE: Reference
-- map('n', ']c', function()
--   if vim.wo.diff then
--     vim.cmd.normal { ']c', bang = true }
--   else
--     gitsigns.nav_hunk 'next'
--   end
-- end, { desc = 'Jump to next git [c]hange' })

-- [[ Splits ]]
keymap.set('n', '<leader>sv', '<C-w>v', { desc = '[S]plit window [V]ertically' })
keymap.set('n', '<leader>sh', '<C-w>s', { desc = '[S]plit window [H]orizontally' })
keymap.set('n', '<leader>se', '<C-w>=', { desc = '[S]plit [E]qualize' })
keymap.set('n', '<leader>sj', '<C-w>-', { desc = '[S]plit make shorter - use motion' })
keymap.set('n', '<leader>sk', '<C-w>+', { desc = '[S]plit make taller - use motion' })
keymap.set('n', '<leader>ss', '<C-w><', { desc = '[S]plit [S]hrink - use motion' })
keymap.set('n', '<leader>sw', '<C-w>>', { desc = '[S]plit [W]iden - use motion' })
keymap.set('n', '<leader>sx', '<C-w>q', { desc = '[S]plit e[X]it - closes current split' })

-- Make j and k navigate wrapped lines correctly
keymap.set('n', 'j', 'gj')
keymap.set('n', 'k', 'gk')

-- Diagnostic keymaps
keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostic ([E]rror) float' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
-- TODO: consider using vim-tmux-navigator instead when I integrate tmux
keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- TODO: Move this to oil setup
-- oil.nvim setup
keymap.set('n', '<leader>N', ':Oil<CR>', { desc = 'Open Oil' })
keymap.set('n', '<leader>n', ':lua require("oil").toggle_float()<CR>', { desc = 'Open Oil' })

-- Close buffer
keymap.set('n', '<leader>x', ':bd<CR>')

-- [[ Graveyard ]]
-- TODO: Adjust this so that it only opens a new terminal if this command has not been run, other wise it shows/hides
-- Alternatively, maybe use zellij for this
-- Open terminal at bottom
-- keymap.set('n', '<leader>`', '<cmd>:10split | term<CR>')
