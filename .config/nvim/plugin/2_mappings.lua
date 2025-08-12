-- [[ Basic Keymaps ]] See `:help vim.keymap.set()`
local keymap = vim.keymap

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- -- TODO: ?
-- keymap.set('c', 'W', 'w')

-- Clear highlights on search when pressing <Esc> in normal mode
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' }) --  See `:help hlsearch`

-- keymap.set('n', '<leader>+', '<C-a>', { desc = 'Increment number' })
-- keymap.set('n', '<leader>-', '<C-x>', { desc = 'Decrement number' })

-- vim.api.nvim_create_user_command('PrintDateTime', function()
--   vim.cmd('spl ~/Notes/' .. os.date '%b-%d-%Y - %H.%M.%S' .. '.md')
--   vim.cmd 'resize -10'
-- end, {})
-- TODO: Capital N for now, later maybe make a notes prefix. Consider remapping oil from space n
-- keymap.set('n', '<leader>N', function()
--   vim.cmd.PrintDateTime()
-- end, { desc = 'Create new note and switch to it' })

-- [[ Splits ]]
keymap.set('n', '<leader>sc', '<C-w>q', { desc = 'Closes current split' })
keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Equalize split size' })
keymap.set('n', '<leader>sh', '<C-w>s', { desc = 'Split window horizontally' })
keymap.set('n', '<leader>sj', '<C-w>-', { desc = 'Make split shorter' })
keymap.set('n', '<leader>sk', '<C-w>+', { desc = 'Make split taller' })
keymap.set('n', '<leader>ss', '<C-w><', { desc = 'Shrink split (horizontally)' })
keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split window vertically' })
keymap.set('n', '<leader>sw', '<C-w>>', { desc = 'Widen split' })
keymap.set('n', '<leader>sx', '<C-w>q', { desc = 'Exit split' })

keymap.set('n', 'K', function()
  vim.lsp.buf.hover({
    border = 'single',
  })
end)

-- Make j and k navigate wrapped lines correctly
keymap.set('n', 'j', 'gj')
keymap.set('n', 'k', 'gk')

-- Diagnostic keymaps
-- keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open diagnostic ([E]rror) float' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Buffer ]]
keymap.set('n', '<S-h>', ':bp<CR>', { desc = "Go left a buffer" })
keymap.set('n', '<S-l>', ':bn<CR>', { desc = "Go right a buffer" })
-- Close buffer
keymap.set('n', '<leader>x', ':bd<CR>', { desc = 'E[x]it current buffer' })

-- File Explorer
keymap.set('n', '<leader>e', ':lua MiniFiles.open()<CR>', { desc = 'File [e]xplorer' })

-- mini.pick
keymap.set('n', '<leader>?',  ':Pick commands<CR>', { desc = 'Find commands' })
keymap.set('n', '<leader>fc', ':Pick colorschemes<CR>', { desc = 'Find colorschemes' })
keymap.set('n', '<leader>ff', ':Pick files<CR>', { desc = 'Find files' })
keymap.set('n', '<leader>fg', ':Pick grep_live<CR>', { desc = 'Find via live grep' })
keymap.set('n', '<leader>fh', ':Pick help<CR>', { desc = 'Find help' })
keymap.set('n', '<leader>fc', ':Pick resume<CR>', { desc = 'Continue previous find' })
keymap.set('n', '<leader>fr', ':Pick visit_paths<CR>', { desc = 'Find recent visits' })
-- keymap.set('n', '<leader>e', ':lua require("oil").toggle_float()<CR>', { desc = 'Open Oil' })

