local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
  add({
    source = 'mason-org/mason.nvim'
  })
  require('mason').setup()

  vim.lsp.enable({
    "gopls"
  })
end)



-- LSP
function asdfg()
  add({
    source = 'neovim/nvim-lspconfig',
    -- Supply dependencies near target plugin
    depends = { 'mason-org/mason.nvim', 'mason-org/mason-lspconfig.nvim' },
  })

  local servers = {
    cssls = {},
    elixirls = {},
    elmls = {
      handlers = {
        ['window/showMessageRequest'] = function(whatever, result)
          -- For some reason, the showMessageRequest handler doesn't work with
          -- the format failed error. It just hangs on the screen and can't
          -- interact with the vim.ui.select thingy. So skip it.
          if result.message:find('Running elm-format failed', 1, true) then
            print(result.message)
            return vim.NIL
          end
          return vim.lsp.handlers['window/showMessageRequest'](whatever, result)
        end,
      },
      settings = {
        elmLS = {
          onlyUpdateDiagnosticsOnSave = true,
          -- This disables elmls specific diagnostics like unused code, missing
          -- signature, etc. The elm make errors still show up.
          disableElmLSDiagnostics = true,
        },
      },
    },
    emmet_ls = {
      filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'svelte' },
    },
    -- gleam = {}, -- RUDE LSP
    gopls = {},
    graphql = {
      filetypes = { 'graphql', 'gql', 'svelte', 'typescriptreact', 'javascriptreact' },
    },
    html = {
      filetypes = { 'html', 'templ', 'heex' },
    },
    htmx = {
      filetypes = { 'html', 'templ', 'heex' },
    },
    jdtls = {

    },
    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
          -- Ignore Lua_LS's noisy `missing-fields` warnings
          diagnostics = { disable = { 'missing-fields' }, globals = { 'vim' } },
        },
      },
    },
    nil_ls = {
      formatting = {
        command = { "nixfmt" },
      },
    },
    pyright = {},
    rust_analyzer = {},
    svelte = {
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd('BufWritePost', {
          pattern = { '*.js', '*.ts' },
          callback = function(ctx)
            -- Here use ctx.match instead of ctx.file
            client.notify('$/onDidChangeTsOrJsFile', { uri = ctx.match })
          end,
        })
      end,
    },
    tailwindcss = {},
    templ = {},
    ts_ls = {},
    -- Zig LS
    zls = {},
  }

  -- Setup the above servers
  require('mason').setup()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  require('mason-lspconfig').setup {
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        -- This handles overriding only values explicitly passed
        -- by the server configuration above. Useful when disabling
        -- certain features of an LSP (for example, turning off formatting for ts_ls)
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        require('lspconfig')[server_name].setup(server)
      end,
    },
    automatic_installation = true,
    ensure_installed = servers
  }

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('rywhel-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end



      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
      -- map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
      -- map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

      local telescope = require('telescope.builtin')
      map('gd', telescope.lsp_definitions, 'Goto Definition')
      map('gr', telescope.lsp_references, 'Goto References')
      map('gi', telescope.lsp_implementations, 'Goto Implementation')
      map('gt', telescope.lsp_type_definitions, 'Goto Type Definition')
      map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

      map('<leader>fs', telescope.lsp_document_symbols, '[F]ind document [S]ymbols')
      map('<leader>fS', telescope.lsp_dynamic_workspace_symbols, 'Workspace Symbols')

      -- TODO: See if there's a way to show diagnostics in current buffer vs diagnostics in project
      map(
        '<leader>fd',
        telescope.diagnostics,
        'Find diagnostics'
      )

      map('[d', vim.diagnostic.goto_prev, 'Go to previous Diagnostic')
      map(']d', vim.diagnostic.goto_next, 'Go to next Diagnostic')
      map('<leader>e', function()
        vim.diagnostic.open_float({
          border = 'single',
        })
      end, 'Show Diagnostic')
      map('<leader>rn', vim.lsp.buf.rename, 'Rename')
      map('<leader>rs', ':LspRestart<CR>', 'Restart')
      map('<leader>a', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local highlight_augroup = vim.api.nvim_create_augroup('rywhel-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('rywhel-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'rywhel-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- The following code creates a keymap to toggle inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- This may be unwanted, since they displace some of your code
      if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, '[T]oggle Inlay [H]ints')
      end
    end,
  })
end

-- formatter
later(function()
  add('stevearc/conform.nvim')
  local conform = require 'conform'

  conform.setup {
    formatters_by_ft = {
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      svelte = { 'prettier' },
      css = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      graphql = { 'prettier' },
      liquid = { 'prettier' },
      python = { 'isort', 'black' },
      nix = { "nixfmt" },
    },
    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    },
  }

  -- Don't think I care about this
  vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
    conform.format {
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    }
  end, { desc = 'Format file or range (in visual mode)' })
end)

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
      'vimdoc'
    },
    auto_install = true,
    highlight = { enable = true },
  })
end)
