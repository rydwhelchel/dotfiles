local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- [[ COLORS ]]
add({ source = 'sainnhe/everforest' })
add({ source = 'rebelot/kanagawa.nvim' })
add({ source = 'rose-pine/neovim' })

-- Rose Pine
now(function()
  vim.o.background = 'dark'
  vim.cmd.colorscheme('rose-pine')
end)

-- [[ MINI PLUGINS]]
--
-- TODO: Look into mini.snippets
now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
end)

-- Icon library - need to enable config.style = 'ascii' on non-nerd font terms
now(function() require('mini.icons').setup() end)

-- Shows buffers/tabs
now(function() require('mini.tabline').setup() end)

-- Beautiful statusline
now(function() require('mini.statusline').setup() end)

-- TODO: Add note creation entries
-- Greeter
now(function() require('mini.starter').setup() end)

-- Around/inside objects - :h mini.ai
later(function() require('mini.ai').setup() end)

-- Better commenting?
later(function() require('mini.comment').setup() end)

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

-- Autopairs
later(function()
  add({ source = "windwp/nvim-autopairs" })
  require('nvim-autopairs').setup()
end)


-- TODO: Review keys defined to see if they match this new setup
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
      { mode = 'n', keys = '<leader>r', desc = '+Re...' },
      { mode = 'n', keys = '<leader>t', desc = '+Notes' },
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

now(function()
  add({ source = "folke/snacks.nvim" })
  require('snacks').setup({
      explorer = { enabled = true, replace_netrw = true },
      input = { enabled = true },
      picker = { enabled = true },
    })
end)
-- {
--     {
--       bigfile = { enabled = true },
--       dashboard = { enabled = true },
--       explorer = { enabled = true },
--       indent = { enabled = true },
--       input = { enabled = true },
--       notifier = {
--         enabled = true,
--         timeout = 3000,
--       },
--       picker = { enabled = true },
--       quickfile = { enabled = true },
--       scope = { enabled = true },
--       scroll = { enabled = true },
--       statuscolumn = { enabled = true },
--       words = { enabled = true },
--       styles = {
--         notification = {
--           -- wo = { wrap = true } -- Wrap notifications
--         }
--       }
--     }
--   }

-- TO DO Comments
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

later(function()
  add({
    source = 'MeanderingProgrammer/render-markdown.nvim',
    -- Note that mini is optional, can change if I move away from mini
    depends = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }
  })

  require('render-markdown').setup({
    completions = { blink = { enabled = true } },
  })
end)

-- TODO: Add indent scope snack
