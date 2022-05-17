local keymap = vim.keymap

local map_opts = {
    noremap = true,
    silent = true,
}

require('bufferline').setup {
    options = {
        mode = 'tabs',
        offsets = {
            {
                filetype = 'NvimTree',
                text = 'File Explorer',
                highlight = 'directory',
                text_align = 'center',
            },
        },
        numbers = 'ordinal',
        show_close_icon = false,
        show_buffer_close_icons = false,
        separator_style = 'slant',
    },
}

keymap.set('', '[b', '<cmd>BufferLineCycleNext<CR>', map_opts)
keymap.set('', ']b', '<cmd>BufferLineCyclePrev<CR>', map_opts)

keymap.set('n', '<M-1>', '<Cmd>BufferLineGoToBuffer 1<CR>', map_opts)
keymap.set('n', '<M-2>', '<Cmd>BufferLineGoToBuffer 2<CR>', map_opts)
keymap.set('n', '<M-3>', '<Cmd>BufferLineGoToBuffer 3<CR>', map_opts)
keymap.set('n', '<M-4>', '<Cmd>BufferLineGoToBuffer 4<CR>', map_opts)
keymap.set('n', '<M-5>', '<Cmd>BufferLineGoToBuffer 5<CR>', map_opts)
keymap.set('n', '<M-6>', '<Cmd>BufferLineGoToBuffer 6<CR>', map_opts)
keymap.set('n', '<M-7>', '<Cmd>BufferLineGoToBuffer 7<CR>', map_opts)
keymap.set('n', '<M-8>', '<Cmd>BufferLineGoToBuffer 8<CR>', map_opts)
keymap.set('n', '<M-9>', '<Cmd>BufferLineGoToBuffer 9<CR>', map_opts)
