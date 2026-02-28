-- =============================================================================
-- Git Configuration (gitsigns.nvim)
-- =============================================================================
--
-- Gitsigns provides git integration: signs in the gutter, hunk operations,
-- blame, and diff viewing.
--
-- DESIGN DECISIONS:
--
-- 1. Simple sign characters
--    We use basic ASCII characters (+, ~, _) for signs to work without
--    Nerd Fonts. These are universally readable and clear.
--
-- 2. Keymap organization
--    - ]c / [c for hunk navigation (vim diff convention)
--    - <leader>h* for hunk operations (stage, reset, preview)
--    - <leader>t* for toggles (blame, deleted lines)
--
-- 3. Visual mode support
--    Stage and reset operations work in visual mode to allow partial
--    hunk staging/resetting.
--
-- =============================================================================

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- Sign column characters (ASCII-friendly)
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },

      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation: ]c and [c for next/previous hunk
        -- Respects vim's diff mode conventions
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { desc = "Jump to next git [c]hange" })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Jump to previous git [c]hange" })

        -- Hunk operations (visual mode)
        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Git [s]tage hunk" })

        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Git [r]eset hunk" })

        -- Hunk operations (normal mode)
        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git [s]tage hunk" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git [r]eset hunk" })
        map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git [S]tage buffer" })
        map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Git [u]ndo stage hunk" })
        map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git [R]eset buffer" })
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git [p]review hunk" })

        -- Blame and diff
        map("n", "<leader>hb", gitsigns.blame_line, { desc = "Git [b]lame line" })
        map("n", "<leader>hd", gitsigns.diffthis, { desc = "Git [d]iff against index" })
        map("n", "<leader>hD", function()
          gitsigns.diffthis("@")
        end, { desc = "Git [D]iff against last commit" })

        -- Toggles
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git [b]lame line" })
        map("n", "<leader>tD", gitsigns.preview_hunk_inline, { desc = "[T]oggle git [D]eleted" })
      end,
    },
  },
}
