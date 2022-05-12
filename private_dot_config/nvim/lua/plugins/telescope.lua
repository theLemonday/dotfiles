local util = require("utils.util")
local keymap = vim.keymap

local options = {
    noremap = true,
    silent = true
}

keymap.set("n", "<leader>ff", function() return require('telescope.builtin').find_files() end, options)
keymap.set("n", "<leader>fg", function() return require('telescope.builtin').live_grep() end, options)
keymap.set("n", "<leader>fb", function() return require('telescope.builtin').buffers() end, options)
keymap.set("n", "<leader>fh", function() return require('telescope.builtin').help_tags() end, options)
keymap.set("n", "<leader>fc", function() return require('telescope.builtin').commands() end, options)

-- default
require 'telescope'.setup {
    defaults = {
        layout_strategy = 'horizontal',
        layout_config = {
            width = 0.95,
            height = 0.9,
            -- prompt_position = 'top',
            -- preview_width = 0.6,
        },
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
        media_files = {
            -- filetypes whitelist
            -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            filetypes = {"png", "webp", "jpg", "jpeg"},
            find_cmd = "rg" -- find command (defaults to `fd`)
        },
        ui_select = {
            require("telescope.themes").get_dropdown {
                -- even more opts
            }
        },
    }
}

    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    -- require('telescope').load_extension('fzf')
    require('telescope').load_extension('media_files')
    require("telescope").load_extension("ui-select")
