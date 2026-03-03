-- =============================================================================
-- LSP Configuration
-- =============================================================================
--
-- This file configures Language Server Protocol (LSP) support for Neovim.
--
-- DESIGN DECISIONS:
--
-- 1. Using vim.lsp.config API (Neovim 0.11+)
--    The new vim.lsp.config/vim.lsp.enable API is the recommended approach.
--    We pull filetypes and root_markers from lspconfig's server definitions
--    to ensure proper server attachment.
--
-- 2. NixOS-first approach
--    On NixOS, LSP servers are installed via Nix and available on PATH.
--    We detect NixOS via /etc/NIXOS and skip Mason entirely. On non-NixOS
--    systems, Mason can be enabled to auto-install servers (future work).
--
-- 3. Capabilities from blink.cmp
--    We use blink.cmp's get_lsp_capabilities() which provides enhanced
--    completion capabilities compared to the older cmp-nvim-lsp approach.
--
-- 4. Formatting via conform.nvim
--    Formatting is handled by conform.nvim rather than LSP formatters.
--    This provides consistent formatting behavior and supports formatters
--    that aren't LSP-based (like stylua, black, etc.).
--
-- =============================================================================

-- Detect NixOS for conditional Mason loading (future use)
local is_nixos = vim.fn.filereadable("/etc/NIXOS") == 1

return {
  -- ---------------------------------------------------------------------------
  -- Fidget: LSP progress notifications
  -- ---------------------------------------------------------------------------
  -- Shows LSP server progress in the corner of the screen.
  -- Useful for seeing when servers are indexing or performing long operations.
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = 0, -- Solid background for better readability
        },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Lazydev: Neovim Lua development support
  -- ---------------------------------------------------------------------------
  -- Provides completion and hover docs for Neovim's Lua API.
  -- Only loads for Lua files to avoid overhead in other filetypes.
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- Conform: Code formatting
  -- ---------------------------------------------------------------------------
  -- Handles all code formatting. We use dedicated formatters rather than
  -- relying on LSP formatting for more consistent results.
  --
  -- DESIGN: Format-on-save is enabled by default but disabled for C/C++
  -- which don't have well-standardized styles.
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "[C]ode [F]ormat",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable format-on-save for languages without standardized styles
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
      -- Formatters by filetype
      -- On NixOS, these are installed via Nix packages
      formatters_by_ft = {
        lua = { "stylua" },
        go = { "gofumpt", "goimports" },
        python = { "isort", "black" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        markdown = { "prettierd" },
        nix = { "nixfmt" },
        elm = { "elm_format" },
        ocaml = { "ocamlformat" },
        -- Elixir/Phoenix
        elixir = { "mix" },
        heex = { "mix" },
        eex = { "mix" },
        -- Web development
        html = { "prettierd" },
        css = { "prettierd" },
        scss = { "prettierd" },
        json = { "prettierd" },
        jsonc = { "prettierd" },
        svelte = { "prettierd" },
        astro = { "prettierd" },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- SchemaStore: JSON schema catalog
  -- ---------------------------------------------------------------------------
  -- Provides schema completions for common JSON files like package.json,
  -- tsconfig.json, etc. Used by jsonls for intelligent completions.
  -- Not lazy-loaded because jsonls config needs it at setup time.
  { "b0o/schemastore.nvim" },

  -- ---------------------------------------------------------------------------
  -- LSP Configuration (nvim-lspconfig)
  -- ---------------------------------------------------------------------------
  -- Uses the new vim.lsp.config API (Neovim 0.11+) with lspconfig for
  -- server definitions (filetypes, root_markers, cmd).
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "j-hui/fidget.nvim",
      "folke/lazydev.nvim",
      "saghen/blink.cmp",
      "b0o/schemastore.nvim",
    },
    config = function()
      -- Get enhanced capabilities from blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Server configurations with custom settings
      -- On NixOS, all servers should be installed via nix packages
      local servers = {
        -- Lua: Neovim configuration and general Lua development
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },

        -- Go: gopls with gofumpt and static analysis
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              usePlaceholders = true,
            },
          },
        },

        -- Rust: rust-analyzer with clippy on save
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = { command = "clippy" },
              cargo = { allFeatures = true },
            },
          },
        },

        -- Python: pyright with basic type checking
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },

        -- TypeScript/JavaScript
        ts_ls = {},

        -- HTML (vscode-html-language-server)
        html = {},

        -- CSS/SCSS/Less (vscode-css-language-server)
        cssls = {},

        -- JSON with schema support (vscode-json-language-server)
        -- Note: schemas configured below after schemastore loads
        jsonls = {},

        -- Tailwind CSS (configured for Phoenix HEEx support)
        tailwindcss = {
          filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "astro", "elixir", "heex", "eex" },
          init_options = {
            userLanguages = {
              elixir = "html-eex",
              eex = "html-eex",
              heex = "html-eex",
            },
          },
          settings = {
            tailwindCSS = {
              includeLanguages = {
                elixir = "html-eex",
                eex = "html-eex",
                heex = "html-eex",
              },
              experimental = {
                classRegex = {
                  -- Phoenix ~H sigil and standard class attributes
                  { "class=\"([^\"]*)\"", "([^\"]*)" },
                },
              },
            },
          },
        },

        -- Svelte
        svelte = {},

        -- Astro
        astro = {},

        -- Elixir: uses elixir-ls command
        elixirls = {
          cmd = { "elixir-ls" },
        },

        -- Markdown
        marksman = {},

        -- Nix: nixd with nixfmt formatting
        nixd = {
          settings = {
            nixd = {
              formatting = { command = { "nixfmt" } },
            },
          },
        },

        -- Zig
        zls = {},

        -- Elm
        elmls = {},

        -- OCaml
        ocamllsp = {},
      }

      -- Setup each server using vim.lsp.config API
      -- We get default_config from lspconfig for filetypes and root_markers
      for server_name, user_config in pairs(servers) do
        -- Try to get lspconfig's default configuration for this server
        local ok, server_def = pcall(require, "lspconfig.configs." .. server_name)

        if ok and server_def and server_def.default_config then
          local default_config = server_def.default_config

          -- Build the final config by merging defaults with user config
          local config = vim.tbl_deep_extend("force", {
            capabilities = capabilities,
            -- Get filetypes from lspconfig (critical for server attachment)
            filetypes = default_config.filetypes,
            -- Get root_markers from lspconfig's root_dir patterns
            root_markers = default_config.root_dir and {} or { ".git" },
            -- Get default cmd if not overridden
            cmd = default_config.cmd,
          }, user_config)

          -- Extract root markers from root_dir if it exists
          -- lspconfig uses root_dir as a function, but we need markers for vim.lsp.config
          -- Common patterns are stored in util.root_pattern
          if default_config.root_dir then
            -- Use sensible defaults based on language
            if server_name == "gopls" then
              config.root_markers = { "go.mod", "go.work", ".git" }
            elseif server_name == "rust_analyzer" then
              config.root_markers = { "Cargo.toml", "rust-project.json", ".git" }
            elseif server_name == "pyright" then
              config.root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "pyrightconfig.json", ".git" }
            elseif server_name == "ts_ls" then
              config.root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" }
            elseif server_name == "lua_ls" then
              config.root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", "stylua.toml", ".git" }
            elseif server_name == "nixd" then
              config.root_markers = { "flake.nix", "default.nix", "shell.nix", ".git" }
            elseif server_name == "zls" then
              config.root_markers = { "build.zig", "zls.json", ".git" }
            elseif server_name == "elmls" then
              config.root_markers = { "elm.json", ".git" }
            elseif server_name == "ocamllsp" then
              config.root_markers = { "dune-project", "dune", ".opam", "*.opam", ".git" }
            elseif server_name == "elixirls" then
              config.root_markers = { "mix.exs", ".git" }
            elseif server_name == "marksman" then
              config.root_markers = { ".marksman.toml", ".git" }
            elseif server_name == "html" then
              config.root_markers = { "package.json", ".git" }
            elseif server_name == "cssls" then
              config.root_markers = { "package.json", ".git" }
            elseif server_name == "jsonls" then
              config.root_markers = { "package.json", ".git" }
            elseif server_name == "tailwindcss" then
              config.root_markers = { "tailwind.config.js", "tailwind.config.ts", "tailwind.config.mjs", "postcss.config.js", ".git" }
            elseif server_name == "svelte" then
              config.root_markers = { "svelte.config.js", "svelte.config.ts", "package.json", ".git" }
            elseif server_name == "astro" then
              config.root_markers = { "astro.config.mjs", "astro.config.ts", "package.json", ".git" }
            else
              config.root_markers = { ".git" }
            end
          end

          -- Enable single file support
          if config.single_file_support == nil then
            config.single_file_support = true
          end

          -- Special configuration for jsonls with schemastore
          if server_name == "jsonls" then
            config.settings = {
              json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
              },
            }
          end

          -- Apply config and enable server
          vim.lsp.config[server_name] = config
          vim.lsp.enable(server_name)
        else
          vim.notify("LSP: Could not find config for " .. server_name, vim.log.levels.WARN)
        end
      end

      -- LSP Attach autocommand: Keymaps and buffer-local settings
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Navigation (using Telescope for better UX)
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
          map("gy", require("telescope.builtin").lsp_type_definitions, "[G]oto T[y]pe Definition")
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          -- Actions
          map("<leader>cr", vim.lsp.buf.rename, "[C]ode [R]ename")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "v" })
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gK", vim.lsp.buf.signature_help, "Signature Help")

          -- Declaration (less common, useful for C/C++ headers)
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- Inlay hints toggle (if supported by server)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method("textDocument/inlayHint") then
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")
          end

          -- Document highlight: highlight references on cursor hold
          if client and client.supports_method("textDocument/documentHighlight") then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end
        end,
      })

      -- Diagnostic configuration
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = true },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.HINT] = "H",
          },
        } or {},
        virtual_text = {
          source = true,
          spacing = 2,
          prefix = vim.g.have_nerd_font and "" or ">>",
        },
      })
    end,
  },
}
