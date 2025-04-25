return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      local telescope = require 'telescope'
      local actions = require 'telescope.actions'

      require('telescope').setup {
        --  All the info you're looking for is in `:help telescope.setup()`
        defaults = {
          path_display = { 'smart' },
          mappings = {
            i = {
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
      vim.keymap.set('n', '<leader>fc', builtin.resume, { desc = '[F]ind [C]ontinue' })
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[F]ind [R]ecent Files' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>fc', ':Telescope colorscheme<CR>', { desc = '[F]ind [C]olor schemes' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>f/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[F]ind [/] in Open Files' })

      -- Shortcut for searching your [p]rivate Neovim configuration files
      vim.keymap.set('n', '<leader>fp', function()
        builtin.find_files {
          cwd = vim.fn.stdpath 'config',
          prompt_title = 'Search Neovim config files by name',
        }
      end, { desc = '[F]ind [P]rivate Config files (Neovim config)' })

      vim.keymap.set('n', '<leader>fP', function()
        builtin.live_grep {
          grep_open_files = true,
          cwd = vim.fn.stdpath 'config',
          prompt_title = 'Live Grep Neovim config files',
        }
      end, { desc = '[F]ind [P]rivate Config files (Neovim config)' })

      -- Shortcut for searching your [p]rivate Neovim configuration files
      vim.keymap.set('n', '<leader>fn', function()
        builtin.find_files {
          cwd = '~/Notes',
          prompt_title = 'Search Notes files by name',
        }
      end, { desc = '[F]ind [N]otes' })

      vim.keymap.set('n', '<leader>fN', function()
        builtin.live_grep {
          grep_open_files = true,
          cwd = '~/Notes',
          prompt_title = 'Live Grep Notes directory',
        }
      end, { desc = '[F]ind [N]otes using grep' })
    end,
  },
}
