local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add({ source = 'neovim/nvim-lspconfig' })
add({ source = 'mason-org/mason.nvim' })

later(function()
  require('mason').setup()
end)

vim.diagnostic.config({ virtual_text = true })

vim.lsp.enable('gopls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('pyright')
vim.lsp.enable('marksman')

vim.lsp.config('luals', {
  cmd = {'lua-language-server'},
  filetypes = {'lua'},
  root_markers = {'.luarc.json', '.luarc.jsonc'},
})
vim.lsp.enable('luals')

vim.lsp.enable('elixirls')

-- TreeSitter
later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  -- Possible to immediately execute code which depends on the added plugin
  require('nvim-treesitter.configs').setup({
    -- Just about every language I've messed with recently
    ensure_installed = {
      'c',
      'fish',
      'elixir',
      'eex',
      'gitignore',
      'gleam',
      'go',
      'gomod',
      'gosum',
      'heex',
      'html',
      'http',
      'java',
      'javadoc',
      'javascript',
      'kotlin',
      'latex',
      'lua',
      'markdown',
      'ocaml',
      'odin',
      'python',
      'regex',
      'rust',
      'sql',
      'svelte',
      'typescript',
      'vimdoc',
      'yaml'
    },
    auto_install = true,
    highlight = { enable = true },
  })
end)

-- Completion - Blink
add({
  source = "saghen/blink.cmp",
  depends = { "rafamadriz/friendly-snippets" },
  checkout = "v1.6.0", -- check releases for latest tag
})
later(function()
  require('blink.cmp').setup({
    keymap = {
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<enter>'] = { 'accept', 'fallback' },
    }
  })
end)

