require('onedark').setup {
    style = 'deep',
    -- options = {
        --     transparency = true
        -- }
    }
    -- require('onedark').load()
    vim.cmd[[colorscheme dracula]]
    -- vim.g.tokyonight_transparent = vim.g.transparent_enabled

    --colorizer
    require'colorizer'.setup (
    -- specific
    {
        '*',
    },
    --default
    {
        css = true,
        css_fn = true,
        mode = 'foreground',
    }
    )

    require("transparent").setup({
        enable = true,
        -- extra_groups = 'all',
        extra_groups = { -- table/string: additional groups that should be cleared

        -- buffer line
        "BufferLineIndicatorSelected",
        "BufferLineTabClose",
        "BufferlineBufferSelected",
        "BufferLineFill",
        "BufferLineBackground",
        "BufferLineSeparator",
        "BufferLineIndicatorSelected",

        -- nvim tree
        'NvimTreeNormal',
    },
    exclude = {
    } -- table: groups you don't want to clear
})

