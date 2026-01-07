-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false

-- Add Pico8 as a new filetype
vim.filetype.add({
  extension = {
    p8 = "pico8",
  },
})
-- Register the Pico8 filetype with lua treesitter grammar
vim.treesitter.language.register("lua", "pico8")
