local util = require'utils.util'

require("bufferline").setup{}

local map_opts = {
    noremap = true,
    silent = true,
}
vim.cmd[[autocmd FileReadPre * :BufferOrderByDirectory<CR>]]
util.map('n', '<leader>bp', '<cmd>BufferPick<CR>', map_opts)
util.map('n', '[b', '<cmd>BufferLineCyclePrev<cr>', map_opts)
util.map('n', ']b', '<cmd>BufferLineCycleNext<cr>', map_opts)
