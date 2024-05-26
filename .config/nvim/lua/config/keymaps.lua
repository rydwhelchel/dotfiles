-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap

-- Add ability to shift selections up and down in visual
map.set("v", "J", ":m '>+1<CR>gv=gv")
map.set("v", "K", ":m '<-2<CR>gv=gv")

-- Enable tabbing and untabbing selections in visual
map.set("v", "<Tab>", ">gv")
map.set("v", "<S-Tab>", "<gv")

-- Easily escape terminal mode
map.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- NOTE: Currently word wrap is disabled so this is unnecessary
-- Remap for dealing with word wrap, lets you use jk within 1 really long line
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
