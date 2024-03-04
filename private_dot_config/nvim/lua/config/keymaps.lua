-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("n", "+", "<C-a>", opts)
keymap("n", "-", "<C-x>", opts)

--select all
keymap("n", "<C-a>", "ggVG", opts)
