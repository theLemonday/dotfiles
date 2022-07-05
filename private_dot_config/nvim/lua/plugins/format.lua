local util = require 'formatter.util'
local keymap = vim.keymap
local renamer = require 'renamer'

require('formatter').setup {
    filetype = {
        lua = {
            function()
                return {
                    exe = 'stylua',
                    args = {
                        '--search-parent-directories',
                        '--stdin-filepath',
                        util.escape_path(util.get_current_buffer_file_path()),
                        '--',
                        '-',
                    },
                    stdin = true,
                }
            end,
        },
        python = {
            function()
                return {
                    exe = 'autopep8',
                    args = {
                        '--aggressive',
                        '--aggressive',
                        util.escape_path(util.get_current_buffer_file_path()),
                    },
                    stdin = true,
                }
            end,
        },
        rust = {
            function()
                return {
                    exe = 'rustfmt',
                    stdin = true,
                }
            end,
        },
    },
}

local format_auto_group = vim.api.nvim_create_augroup('FormatAutogroup', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', { command = 'FormatWrite', group = format_auto_group, pattern = '*' })

local ns = {
    noremap = true,
    silent = true,
}

renamer.setup {
    with_popup = true,
    show_refs = true,
}

keymap.set('i', '<F2>', function()
    renamer.rename { empty = false }
end, ns)

keymap.set('n', '<leader>rn', function()
    renamer.rename { empty = false }
end, ns)

keymap.set('v', '<leader>rn', function()
    renamer.rename { empty = false }
end, ns)
