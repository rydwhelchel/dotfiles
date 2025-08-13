local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- [[ COLORS ]]
add({ source = 'sainnhe/everforest' })
add({ source = 'rebelot/kanagawa.nvim' })
add({ source = 'rose-pine/neovim' })
--
-- -- Minispring
-- now(function()
--   vim.o.termguicolors = true
--   vim.cmd('colorscheme minispring')
-- end)

-- -- Kanagawa
-- now(function()
--   require('kanagawa').load('wave')
-- end)

-- -- Everforest
-- now(function()
--   vim.g.everforest_enable_italic = true
--   vim.o.background = 'dark'
--   vim.g.everforest_background = 'hard'
--
--   vim.cmd.colorscheme('everforest')
-- end)

-- Rose Pine
now(function()
  vim.o.background = 'dark'
  vim.cmd.colorscheme('rose-pine')
end)

-- -- Mini Hues
-- now(function()
-- 	require('mini.hues').setup({
-- 		-- -- Teal background      Orange-ish foreground
-- 		-- background = '#02141e', foreground = '#f77923' })
-- 		--
-- 		-- -- Purple background    Ice blue-ish foreground
-- 		-- background = '#12061d', foreground = '#31fef7' })
-- 		--
-- 		-- Brown background     Orange-ish foreground
-- 		background = '#100500', foreground = '#ff6a01' })
-- end)


-- [[ MINI PLUGINS]]
--
-- TODO: Look into mini.snippets
now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
end)

-- File Picker
now(function() require('mini.files').setup() end)

-- Icon library
now(function() require('mini.icons').setup() end)

-- Shows buffers/tabs
now(function() require('mini.tabline').setup() end)

-- Beautiful statusline
now(function() require('mini.statusline').setup() end)

-- TODO: Add note creation entries
-- Greeter
now(function() require('mini.starter').setup() end)

-- Sessionizer
now(function() require('mini.sessions').setup() end)

-- Safely execute later
-- Around/inside objects - :h mini.ai
later(function() require('mini.ai').setup() end)

-- Better commenting?
later(function() require('mini.comment').setup() end)

-- Built in picker
later(function() require('mini.pick').setup() end)

-- A bunch of extras, especially for picker
later(function() require('mini.extra').setup() end)

-- TODO: Surround tools, need to play with
later(function() require('mini.surround').setup() end)

-- Adds fuzzy search algorithm to be used
later(function() require('mini.fuzzy').setup() end)

-- Completion
later(function() require('mini.completion').setup() end)

-- Track file system visits
later(function() require('mini.visits').setup() end)

-- TODO: Look into reassigning "g" leader
-- Splitjoin makes it easier to split args across lines (or join them)
later(function() require('mini.splitjoin').setup() end)

-- Sneak/flash
later(function()
  require('mini.jump2d').setup({
    view = {
      -- Whether to dim lines with at least one jump spot
      dim = true,
    }
  })
end)

-- Helpful guide showing current indent scope
later(function() require('mini.indentscope').setup() end)

-- Highlights word under cursor
later(function() require('mini.cursorword').setup() end)

-- Easy config for moving blocks of text
later(function()
  require('mini.move').setup({
    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = '<S-Tab>',
      right = '<Tab>',
      down = '<S-j>',
      up = '<S-k>',

      -- Move current line in Normal mode
      line_left = '<S-Tab>',
      line_right = '<Tab>',
      -- line_down = '<S-j>',
      -- line_up = '<S-k>',
    },

    -- Options which control moving behavior
    options = {
      -- Automatically reindent selection during linewise vertical move
      reindent_linewise = true,
    },
  })
end)

-- Minimap
later(function()
  local map = require('mini.map')
  map.setup({
    integrations = {
      map.gen_integration.builtin_search(),
      map.gen_integration.diff(),
      map.gen_integration.diagnostic(),
    },
  })

  -- [[ Minimap ]]
  vim.keymap.set('n', '<Leader>mf', MiniMap.toggle_focus)
  vim.keymap.set('n', '<Leader>mr', MiniMap.refresh)
  vim.keymap.set('n', '<Leader>mt', MiniMap.toggle)
end)

later(function()
  -- Copying default config in for inspiration
  require('mini.pairs').setup({
    -- In which modes mappings from this `config` should be created
    modes = { insert = true, command = false, terminal = false },

    -- Global mappings. Each right hand side should be a pair information, a
    -- table with at least these fields (see more in |MiniPairs.map|):
    -- - <action> - one of 'open', 'close', 'closeopen'.
    -- - <pair> - two character string for pair to be used.
    -- By default pair is not inserted after `\`, quotes are not recognized by
    -- <CR>, `'` does not insert pair after a letter.
    -- Only parts of tables can be tweaked (others will use these defaults).
    mappings = {
      ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
      ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
      ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

      [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
      [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
      ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

      ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
      ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
      ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
    },
  })
end)

-- -- Git Diff stuff, not sure about right now
-- later(function()
--   -- Default config mostly
--   require('mini.diff').setup({
--     -- Options for how hunks are visualized
--     view = {
--       -- Visualization style. Possible values are 'sign' and 'number'.
--       -- Default: 'number' if line numbers are enabled, 'sign' otherwise.
--       style = vim.go.number and 'number' or 'sign',
--
--       -- Signs used for hunks with 'sign' view
--       signs = { add = '+', change = '*', delete = '-' },
--
--       -- Priority of used visualization extmarks
--       priority = 199,
--     },
--
--     -- Source(s) for how reference text is computed/updated/etc
--     -- Uses content from Git index by default
--     source = nil,
--
--     -- Delays (in ms) defining asynchronous processes
--     delay = {
--       -- How much to wait before update following every text change
--       text_change = 200,
--     },
--
--     -- Module mappings. Use `''` (empty string) to disable one.
--     mappings = {
--       -- Apply hunks inside a visual/operator region
--       apply = 'gh',
--
--       -- Reset hunks inside a visual/operator region
--       reset = 'gH',
--
--       -- Hunk range textobject to be used inside operator
--       -- Works also in Visual mode if mapping differs from apply and reset
--       textobject = 'gh',
--
--       -- Go to hunk range in corresponding direction
--       goto_first = '[H',
--       goto_prev = '[h',
--       goto_next = ']h',
--       goto_last = ']H',
--     },
--
--     -- Various options
--     options = {
--       -- Diff algorithm. See `:h vim.diff()`.
--       algorithm = 'histogram',
--
--       -- Whether to use "indent heuristic". See `:h vim.diff()`.
--       indent_heuristic = true,
--
--       -- The amount of second-stage diff to align lines
--       linematch = 60,
--
--       -- Whether to wrap around edges during hunk navigation
--       wrap_goto = false,
--     },
--   })
-- end)

-- Telescope
later(function()
  require('mini.fuzzy').setup()

  add({
    source = 'nvim-telescope/telescope.nvim',
    depends = { 'nvim-lua/plenary.nvim' }
  })
  require('telescope').setup({
    defaults = {
      generic_sorter = require('mini.fuzzy').get_telescope_sorter
    }
  })
  local keymap = vim.keymap

  local builtin = require('telescope.builtin')
  keymap.set('n', '<leader>?', builtin.commands, { desc = 'Command help' })
  keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
  keymap.set('n', '<leader>fc', builtin.colorscheme, { desc = 'find live grep' })
  keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'find find files' })
  keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'find live grep' })
  keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'find help tags' })
end)

-- Mini's "WhichKey"
later(function()
  local miniclue = require('mini.clue')
  miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- `f` key
      { mode = 'n', keys = 'f' },
      { mode = 'x', keys = 'f' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      { mode = 'n', keys = '<leader>s', desc = '+Split' },
      { mode = 'n', keys = '<leader>f', desc = '+Find' },
      { mode = 'n', keys = '<leader>m', desc = '+Minimap' },
      { mode = 'n', keys = '<leader>r', desc = '+Re...' },
      { mode = 'n', keys = '<leader>t', desc = '+Toggle' },
      -- Enhance this by adding descriptions for <Leader> mapping groups
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },

    window = {
      config = { width = 50 },
      delay = 400,
    },
  })
end)

-- Open help & man pages in vertical split by default
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "man" },
  command = "wincmd L",
})

-- [[ OTHER PLUGINS ]]
--
-- LSP
now(function()
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
end)

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

-- TODO Comments
later(function()
  add({
    source = "folke/todo-comments.nvim",
    depends = { "nvim-lua/plenary.nvim" }
  })
  local todo_comments = require("todo-comments")


  vim.keymap.set("n", "]t", function()
    todo_comments.jump_next()
  end, { desc = "Next todo comment" })

  vim.keymap.set("n", "[t", function()
    todo_comments.jump_prev()
  end, { desc = "Previous todo comment" })

  todo_comments.setup()
end)
