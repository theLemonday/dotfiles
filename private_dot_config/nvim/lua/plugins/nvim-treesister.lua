-- Load custom tree-sitter grammar for org filetype
require('orgmode').setup_ts_grammar()

require('nvim-treesitter.configs').setup {
    -- A list of parser names, or "all"
    ensure_installed = { 'cpp', 'c', 'json', 'lua', 'go', 'rust', 'org', 'dockerfile' },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- List of parsers to ignore installing (for "all")
    ignore_install = {},

    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        disable = { 'org' },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = { 'org' }, -- Required since TS highlighter doesn't support all syntax features (conceal)
    },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
}

local icon_set = require('symbols').icons_set
local extra_icons_set = require('symbols').extra

-- Customized config
require('nvim-gps').setup {

    disable_icons = false, -- Setting it to true will disable all icons

    icons = {
        ['class-name'] = icon_set.Class, -- Classes and class-like objects
        ['function-name'] = icon_set.Function, -- Functions
        ['method-name'] = icon_set.Method, -- Methods (functions inside class-like objects)
        ['container-name'] = extra_icons_set.Namespace, -- Containers (example: lua tables)
        ['tag-name'] = icon_set.Property, -- Tags (example: html tags)
    },

    -- Add custom configuration per language or
    -- Disable the plugin for a language
    -- Any language not disabled here is enabled by default
    languages = {
        -- Some languages have custom icons
        ['json'] = {
            icons = {
                ['array-name'] = ' ',
                ['object-name'] = ' ',
                ['null-name'] = '[] ',
                ['boolean-name'] = 'ﰰﰴ ',
                ['number-name'] = '# ',
                ['string-name'] = ' ',
            },
        },
        ['latex'] = {
            icons = {
                ['title-name'] = '# ',
                ['label-name'] = ' ',
            },
        },
        ['norg'] = {
            icons = {
                ['title-name'] = ' ',
            },
        },
        ['toml'] = {
            icons = {
                ['table-name'] = ' ',
                ['array-name'] = ' ',
                ['boolean-name'] = 'ﰰﰴ ',
                ['date-name'] = ' ',
                ['date-time-name'] = ' ',
                ['float-name'] = ' ',
                ['inline-table-name'] = ' ',
                ['integer-name'] = '# ',
                ['string-name'] = ' ',
                ['time-name'] = ' ',
            },
        },
        ['verilog'] = {
            icons = {
                ['module-name'] = ' ',
            },
        },
        ['yaml'] = {
            icons = {
                ['mapping-name'] = ' ',
                ['sequence-name'] = ' ',
                ['null-name'] = '[] ',
                ['boolean-name'] = 'ﰰﰴ ',
                ['integer-name'] = '# ',
                ['float-name'] = ' ',
                ['string-name'] = ' ',
            },
        },
        ['yang'] = {
            icons = {
                ['module-name'] = ' ',
                ['augment-path'] = ' ',
                ['container-name'] = ' ',
                ['grouping-name'] = ' ',
                ['typedef-name'] = ' ',
                ['identity-name'] = ' ',
                ['list-name'] = '﬘ ',
                ['leaf-list-name'] = ' ',
                ['leaf-name'] = ' ',
                ['action-name'] = ' ',
            },
        },

        -- Disable for particular languages
        -- ["bash"] = false, -- disables nvim-gps for bash
        -- ["go"] = false,   -- disables nvim-gps for golang

        -- Override default setting for particular languages
        -- ["ruby"] = {
        --	separator = '|', -- Overrides default separator with '|'
        --	icons = {
        --		-- Default icons not specified in the lang config
        --		-- will fallback to the default value
        --		-- "container-name" will fallback to default because it's not set
        --		["function-name"] = '',    -- to ensure empty values, set an empty string
        --		["tag-name"] = ''
        --		["class-name"] = '::',
        --		["method-name"] = '#',
        --	}
        --}
    },

    separator = ' > ',

    -- limit for amount of context shown
    -- 0 means no limit
    depth = 0,

    -- indicator used when context hits depth limit
    depth_limit_indicator = '..',
}
