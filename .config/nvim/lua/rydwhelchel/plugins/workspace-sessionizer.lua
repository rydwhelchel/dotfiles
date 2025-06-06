return {
  'rmagatti/auto-session',
  config = function()
    local auto_session = require 'auto-session'

    auto_session.setup {
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { '~/', '~/Dev/', '~/Downloads', '~/Documents', '~/Desktop/' },
    }

    local keymap = vim.keymap

    keymap.set('n', '<leader>wr', '<cmd>SessionRestore<CR>', { desc = '[W]orkspace [R]estore' }) -- restore last workspace session for current directory
    keymap.set('n', '<leader>wp', '<cmd>SessionSave<CR>', { desc = '[W]orkspace [P]ersist' }) -- save workspace session for current working directory
  end,
}
