local util = require "utils.util"
require'nvim-tree'.setup{
    filters = {
        dotfiles = true,
        custom = {
            ".*\\~",
        },
    }
}

util.map("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", {noremap = true, silent = true})
vim.cmd [[autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]]
