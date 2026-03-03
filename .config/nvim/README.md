# Neovim Configuration

A modular Neovim configuration designed for NixOS with future support for non-NixOS systems.

## Philosophy

1. **NixOS-first**: LSP servers and tools are installed via Nix, not Mason
2. **Modular**: Each plugin category has its own file in `lua/plugins/`
3. **Documented**: Design decisions are explained in code comments
4. **Portable**: Can be extended to support non-NixOS via Mason (future work)

## Directory Structure

```
~/.config/nvim/
├── init.lua              # Entry point (leader keys, loads modules)
├── lua/
│   ├── options.lua       # Vim options
│   ├── keymaps.lua       # Global keybindings
│   ├── lazy-bootstrap.lua # Lazy.nvim installation
│   ├── lazy-plugins.lua  # Plugin loading configuration
│   └── plugins/          # Plugin configurations
│       ├── lsp.lua       # LSP, formatting (conform), diagnostics
│       ├── completion.lua # Autocompletion (blink.cmp)
│       ├── telescope.lua # Fuzzy finder
│       ├── treesitter.lua # Syntax highlighting
│       ├── git.lua       # Git integration (gitsigns)
│       ├── ui.lua        # UI (snacks, noice, which-key)
│       ├── editor.lua    # Editor features (mini.nvim, todo-comments)
│       └── theme.lua     # Colorscheme (tokyonight)
├── CLAUDE.md             # AI assistant directives
└── README.md             # This file
```

## Design Decisions

### Why Traditional lspconfig API?

The newer Neovim 0.11+ API (`vim.lsp.config`/`vim.lsp.enable`) requires manual filetype and root pattern configuration. The traditional `require("lspconfig")[server].setup()` handles these automatically, making it more reliable.

### Why blink.cmp over nvim-cmp?

- Modern, faster completion engine
- Better defaults out of the box
- Simpler configuration
- Having both causes conflicts (duplicate menus, keymap issues)

### Why Flat plugins/ Structure?

- Easier to navigate than kickstart/custom split
- All configuration in one place
- Clear file naming by category

### NixOS Detection

```lua
local is_nixos = vim.fn.filereadable("/etc/NIXOS") == 1
```

This checks for the sentinel file that NixOS always creates. Used for conditional plugin behavior.

### NixOS + Treesitter Integration

This was tricky to get right. Key learnings:

**1. Lazy.nvim resets packpath by default**

Lazy.nvim's `performance.reset_packpath` is `true` by default, which removes Nix-installed plugins from the runtimepath. Fix in `lazy-plugins.lua`:

```lua
require("lazy").setup({...}, {
  performance = {
    reset_packpath = false,  -- Preserve Nix-installed plugins
  },
})
```

**2. New nvim-treesitter has a different API**

The Nix-packaged nvim-treesitter uses the new API where `nvim-treesitter.configs` no longer exists. Instead of:

```lua
-- OLD API (doesn't work with Nix version)
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
})
```

Use Neovim's built-in treesitter:

```lua
-- NEW API (works with Nix version)
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
```

**3. Don't use extraLuaConfig with your own init.lua**

Home-manager's `programs.neovim.extraLuaConfig` runs before plugins load and conflicts with a custom `~/.config/nvim/init.lua`. Keep treesitter config in your neovim config, not Nix.

**4. Nix config for treesitter**

In `~/nixos-config/home/common.nix`:

```nix
programs.neovim = {
  enable = true;
  plugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars  # Installs plugin + all parsers
  ];
  # Don't use extraLuaConfig - configure in ~/.config/nvim instead
};
```

## Configured LSP Servers

| Server | Language | Notes |
|--------|----------|-------|
| lua_ls | Lua | Neovim config, general Lua |
| gopls | Go | gofumpt, staticcheck enabled |
| rust_analyzer | Rust | clippy on save |
| pyright | Python | basic type checking |
| ts_ls | TypeScript/JavaScript | |
| html | HTML | vscode-langservers-extracted |
| cssls | CSS/SCSS/Less | vscode-langservers-extracted |
| jsonls | JSON | vscode-langservers-extracted, SchemaStore |
| tailwindcss | Tailwind CSS | class completions, Phoenix HEEx support |
| svelte | Svelte | |
| astro | Astro | |
| elixirls | Elixir | Phoenix/HEEx support, uses `elixir-ls` command |
| marksman | Markdown | |
| nixd | Nix | nixfmt formatting |
| zls | Zig | |
| elmls | Elm | |
| ocamllsp | OCaml | ocamlformat |

## Adding a New LSP Server

1. Install the server via Nix (on NixOS) or ensure it's on PATH
2. Add configuration to `lua/plugins/lsp.lua` in the `servers` table:

```lua
servers = {
  -- ... existing servers ...

  new_server = {
    settings = {
      -- server-specific settings
    },
  },
}
```

3. (Optional) Add formatter to conform.nvim's `formatters_by_ft`

## Enabling Mason (Non-NixOS)

For non-NixOS systems, Mason can be added to auto-install LSP servers:

1. Add Mason plugins to `lua/plugins/lsp.lua`:
```lua
{
  "williamboman/mason.nvim",
  cond = not is_nixos,
  config = function()
    require("mason").setup()
  end,
},
{
  "williamboman/mason-lspconfig.nvim",
  cond = not is_nixos,
  -- configure mason-lspconfig here
},
```

2. Modify the server setup loop to use mason-lspconfig handlers

## Key Bindings

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `gK` | Signature help |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>cf` | Format buffer |
| `<leader>th` | Toggle inlay hints |

### Search (Telescope)
| Key | Action |
|-----|--------|
| `<leader>sf` | Search files |
| `<leader>sg` | Search by grep |
| `<leader>sh` | Search help |
| `<leader>sk` | Search keymaps |
| `<leader>/` | Fuzzy search in buffer |
| `<leader><leader>` | Find buffers |
| `<C-j>` / `<C-k>` | Navigate results (in picker) |

### Completion (blink.cmp)
| Key | Action |
|-----|--------|
| `<C-j>` / `<C-k>` | Navigate completion menu |
| `<CR>` | Accept completion |
| `<C-y>` | Accept completion (vim default) |
| `<C-n>` / `<C-p>` | Navigate completion (vim default) |
| `<C-space>` | Toggle documentation |

### Git
| Key | Action |
|-----|--------|
| `]c` / `[c` | Next/previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |
| `<leader>tb` | Toggle line blame |

## Troubleshooting

### LSP Not Attaching

1. Check server is installed: `:!which <server-name>`
2. Check LSP status: `:LspInfo`
3. Check for errors: `:LspLog`

### Completion Not Working

1. Ensure you're in insert mode
2. Check blink.cmp is loaded: `:Lazy` and look for blink.cmp
3. Check LSP is attached: `:LspInfo`

### Formatting Not Working

1. Check formatter is installed: `:!which <formatter>`
2. Check conform status: `:ConformInfo`
3. Verify filetype: `:set ft?`

### Treesitter Highlighting Not Working (NixOS)

1. Check parser exists:
   ```vim
   :lua print(vim.inspect(vim.api.nvim_get_runtime_file('parser/elixir.so', true)))
   ```

2. Check if treesitter highlight is active:
   ```vim
   :lua print(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil)
   ```

3. Verify `reset_packpath = false` is set in lazy.nvim config

4. Check runtimepath includes Nix paths:
   ```vim
   :lua for _, p in ipairs(vim.opt.runtimepath:get()) do if p:match('treesitter') then print(p) end end
   ```
