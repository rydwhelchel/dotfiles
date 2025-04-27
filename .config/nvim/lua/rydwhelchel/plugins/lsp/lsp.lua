return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Mason
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim',       opts = {} },

    -- Allows extra capabilities provided by nvim-cmp
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    --  This function gets run when an LSP attaches to a particular buffer.
    --    That is to say, every time a new file is opened that is associated with
    --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
    --    function will be executed to configure the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- Create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        -- TODO: Compare with Josean's keymaps

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

        --  For example, in C this would take you to the header.
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- NOTE: Try this and if it works strangely try <cmd>Telescope diagnostics bufnr=0<CR>
        map('<leader>D', require('telescope.builtin').diagnostics, 'Line [D]iagnostics')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[F]ind [D]ocument [S]ymbols')

        -- jump to previous diagnostic in buffer
        map('[d', vim.diagnostic.goto_prev, 'Go to previous [D]iagnostic')

        -- jump to next diagnostic in buffer
        map(']d', vim.diagnostic.goto_next, 'Go to next [D]iagnostic')

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Restart LSP server if needed
        map('<leader>rs', ':LspRestart<CR>', '[R]e[s]tart')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
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
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
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

    -- TODO: Do I want this?
    -- Change the Diagnostic symbols in the sign column (gutter)
    -- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    -- for type, icon in pairs(signs) do
    --   local hl = "DiagnosticSign" .. type
    --   vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    -- end

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    --  TODO: Python LSP, SQL LSP
    -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
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

    -- ~~~ START RUDE LSPS ~~~
    require('lspconfig').gleam.setup({})
    -- ~~~ END RUDE LSPS   ~~~

    require('mason').setup {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    }

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    -- Just for servers
    vim.list_extend(ensure_installed, {
      'prettier', -- prettier formatter
      'isort',    -- python formatter
      'black',    -- python formatter
      'pylint',   -- python formatter
      'eslint_d', -- js linter
    })

    -- Install the above servers
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- Setup the above servers
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
      ensure_installed = servers,
    }
  end,
}
