-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Opens man and help pages to the right
-- NOTE: But why wincmd?
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'help', 'man' },
  command = 'wincmd L',
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '*.templ' }, callback = vim.lsp.buf.format })
