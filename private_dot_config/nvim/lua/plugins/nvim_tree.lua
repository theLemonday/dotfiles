local util = require "utils.util"
require'nvim-tree'.setup{
    filters = {
        dotfiles = true,
        custom = {
            ".*\\~",
        },
    },
    view = {
        side = 'right'
    },
    renderer = {
        indent_markers = {
            enable = false,
            icons = {
                corner = "└ ",
                edge = "│ ",
                none = "  ",
            },
        },
        icons = {
            webdev_colors = true,
            git_placement = "before",
        }
    },
}

util.map("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", {noremap = true, silent = true})
vim.cmd [[autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]]
