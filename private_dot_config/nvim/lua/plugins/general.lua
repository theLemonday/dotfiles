local keymap = vim.keymap

require 'plugins.bufferline'
require 'plugins.color'
require 'plugins.custom'
require 'plugins.format'
require 'plugins.indent_blankline'

-- file related
require 'plugins.nvim-treesister'
--require 'plugins.filetype'
require 'plugins.org_mode'
--require 'plugins.symbols_outline'

require 'plugins.nvim_tree'
require 'plugins.session'
require 'plugins.statusline'
require 'plugins.telescope'
require 'plugins.terminal'
require 'plugins.lsp_config'

-- local icons = require 'nvim-nonicons'
-- icons.get 'file'

require('Comment').setup {
    pre_hook = function(ctx)
        local U = require 'Comment.utils'

        local location = nil
        if ctx.ctype == U.ctype.block then
            location = require('ts_context_commentstring.utils').get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require('ts_context_commentstring.utils').get_visual_start_location()
        end

        return require('ts_context_commentstring.internal').calculate_commentstring {
            key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
            location = location,
        }
    end,
}

require('focus').setup {}
keymap.set('n', '<leader>h', ':FocusSplitLeft<CR>', { silent = true })
keymap.set('n', '<leader>j', ':FocusSplitDown<CR>', { silent = true })
keymap.set('n', '<leader>k', ':FocusSplitUp<CR>', { silent = true })
keymap.set('n', '<leader>l', ':FocusSplitRight<CR>', { silent = true })

vim.g.mkdp_auto_start = 1
vim.g.mkdp_refresh_slow = 1

vim.notify = require 'notify'
require('notify').setup {
    background_colour = '#000000',
}

require('nvim-web-devicons').setup {
    -- your personnal icons can go here (to override)
    -- you can specify color or cterm_color instead of specifying both of them
    -- DevIcon will be appended to `name`
    override = {
        zsh = {
            icon = '',
            color = '#428850',
            cterm_color = '65',
            name = 'Zsh',
        },
        lua = {
            icon = '',
        },
    },
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = true,
}
