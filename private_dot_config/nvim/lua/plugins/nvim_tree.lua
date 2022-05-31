local keymap = vim.keymap

require('nvim-tree').setup {
    filters = {
        dotfiles = true,
        custom = {
            '.*\\~',
        },
    },
    view = {
        side = 'right',
    },
    renderer = {
        indent_markers = {
            enable = false,
            icons = {
                corner = '└ ',
                edge = '│ ',
                none = '  ',
            },
        },
        icons = {
            webdev_colors = true,
            git_placement = 'before',
        },
    },
}

keymap.set('n', '<C-S-e>', '<cmd>NvimTreeToggle<cr>', { noremap = true, silent = true })
vim.cmd [[autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]]
