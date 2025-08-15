-- [[ Basic Keymaps ]] See `:help vim.keymap.set()`
local keymap = vim.keymap

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Automagically replace :W with :w - No more ":Wqa is not a command!"
keymap.set('c', 'W', 'w')

-- Clear highlights on search when pressing <Esc> in normal mode
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- [[ Splits ]]
keymap.set('n', '<leader>sc', '<C-w>q', { desc = 'Closes current split' })
keymap.set('n', '<leader>se', '<C-w>=', { desc = 'Equalize split size' })
keymap.set('n', '<leader>sd', '<C-w>s', { desc = 'Split window (down)' })
keymap.set('n', '<leader>sj', '<C-w>-', { desc = 'Make split shorter' })
keymap.set('n', '<leader>sk', '<C-w>+', { desc = 'Make split taller' })
keymap.set('n', '<leader>ss', '<C-w><', { desc = 'Shrink split (horizontally)' })
keymap.set('n', '<leader>sv', '<C-w>v', { desc = 'Split window (right)' })
keymap.set('n', '<leader>sw', '<C-w>>', { desc = 'Widen split' })
keymap.set('n', '<leader>sx', '<C-w>q', { desc = 'Exit split' })

-- Add border to lsp buf hover
keymap.set('n', 'K', function()
  vim.lsp.buf.hover({
    border = 'single',
  })
end)

-- Make j and k navigate wrapped lines correctly
keymap.set('n', 'j', 'gj')
keymap.set('n', 'k', 'gk')

keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Pipe selection and insert output from helix
vim.keymap.set('x', '<leader>\\', function()
  vim.ui.input({ prompt = "Filter selection through: " }, function(input)
    if input and #input > 0 then
      local escaped = vim.fn.shellescape(input)
      vim.cmd(string.format("'<,'>!%s", escaped))
    end
  end)
end, { desc = 'Replace selection with shell command output' })
keymap.set('x', '<leader>|', function() vim.ui.input({ prompt = "Pipe selection to shell command: " }, function(input)
  if input and #input > 0 then
    local escaped = vim.fn.shellescape(input)
    local cmd = string.format("'<,'>w !%s", escaped)
    vim.cmd(cmd)
  end
end) end, { desc = 'Pipe selection to shell command' })

-- [[ Buffer ]]
keymap.set('n', '<S-h>', ':bp<CR>', { desc = "Go left a buffer" })
keymap.set('n', '<S-l>', ':bn<CR>', { desc = "Go right a buffer" })
-- Close buffer
keymap.set('n', '<leader>x', ':bd<CR>', { desc = 'Exit current buffer' })

-- File Explorer
keymap.set('n', '<leader>n', function() Snacks.explorer() end, { desc = 'File explorer' })

-- LazyGit
keymap.set('n', '<leader>lg', function() Snacks.lazygit.open() end, { desc = 'File explorer' })

-- [[ LSP ]]
keymap.set('n', '<leader>e', function() vim.diagnostic.open_float({ border = 'single' }) end, { desc = 'Code action'})
-- C commands
keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, { desc = 'Code action'})
-- G commands
keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Find definitions'})
keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Find declarations'})
keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { desc = 'Find references'})
-- R commands
keymap.set('n', '<leader>rn', function() vim.lsp.buf.rename() end, { desc = 'Rename'})

-- [[ Snacks picker ]]
-- ? commands
keymap.set('n', '<leader>?c', function() Snacks.picker.commands() end, { desc = 'Find commands'})
keymap.set('n', '<leader>?k', function() Snacks.picker.keymaps() end, { desc = 'Find keymaps'})
keymap.set('n', '<leader>?h', function() Snacks.picker.help() end, { desc = 'Find help'})
-- F commands
keymap.set('n', '<leader>f<space>', function() Snacks.picker.smart() end, { desc = 'Find w/smart'})
keymap.set('n', '<leader>fp', function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = 'Find config (private)'})
keymap.set('n', '<leader>ff', function() Snacks.picker.files() end, { desc = 'Find files'})
keymap.set('n', '<leader>fq', function() Snacks.picker.qflist() end, { desc = 'Find quickfixes'})
keymap.set('n', '<leader>fh', function() Snacks.picker.recent() end, { desc = 'Find recent file history'})
keymap.set('n', '<leader>fg', function() Snacks.picker.grep() end, { desc = 'Find via grep'})
-- Alias for fg
keymap.set('n', '<leader>/', function() Snacks.picker.grep() end, { desc = 'Find via grep'})
keymap.set('n', '<leader>fc', function() Snacks.picker.colorschemes() end, { desc = 'Find color schemes'})
-- One-shots
keymap.set('n', '<leader>d', function() Snacks.picker.diagnostics_buffer() end, { desc = 'Document diagnostics'})
keymap.set('n', '<leader>D', function() Snacks.picker.diagnostics() end, { desc = 'Workspace diagnostics'})
