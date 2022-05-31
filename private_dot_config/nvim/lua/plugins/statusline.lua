local gps = require 'nvim-gps'

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'onedark',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { 'alpha' },
        always_divide_middle = true,
        globalstatus = true,
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { gps.get_location, cond = gps.is_available } },
        -- lualine_x = {'filetype'},
        lualine_x = { 'filename' },
        -- lualine_y = {'progress'},
        lualine_y = { 'fileformat' },
        -- lualine_z = {'location'}
        lualine_z = { require('auto-session-library').current_session_name },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        -- lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    extensions = {
        'nvim-tree',
        'toggleterm',
    },
}
