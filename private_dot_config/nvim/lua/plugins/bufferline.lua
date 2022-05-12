local util = require'utils.util'

require("bufferline").setup{
    options = {
    separator_style = "slant",
    }
}

util.map("n", "<leader>no", "<cmd> lua require'notify''test' <cr>", {noremap = true, silent = true})
util.map("", "[b", "<cmd>BufferLineCycleNext<CR>", {noremap = true, silent = true})
util.map("", "]b", "<cmd>BufferLineCyclePrev<CR>", {noremap = true, silent = true})
