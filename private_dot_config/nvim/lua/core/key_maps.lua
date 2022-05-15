local keymap = vim.keymap.set
local ns = {
    noremap = true,
    silent = true
}

vim.g.mapleader = ' '
keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
keymap('n', 'H', '^', ns)
keymap('n', 'L', '$', ns)
keymap('n', '<C-h>', '<cmd>wincmd h<cr>', ns)
keymap('n', '<C-j>', '<cmd>wincmd j<cr>', ns)
keymap('n', '<C-k>', '<cmd>wincmd k<cr>', ns)
keymap('n', '<C-l>', '<cmd>wincmd l<cr>', ns)
