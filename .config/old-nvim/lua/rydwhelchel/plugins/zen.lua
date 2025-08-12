return {
  'folke/zen-mode.nvim',
  opts = {},
  config = function()
    require('zen-mode').setup {
      window = {
        width = 103,
      },
    }
    vim.keymap.set('n', '<leader>zen', ':ZenMode<CR>')
  end,
}
