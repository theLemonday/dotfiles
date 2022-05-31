local keymap = vim.keymap.set
local ns = {
    noremap = true,
    silent = true
}

vim.g.mapleader = ' '
keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
keymap('n', 'H', '^', ns)
keymap('n', 'L', '$', ns)
