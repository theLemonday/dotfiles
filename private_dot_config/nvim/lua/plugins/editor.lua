return {
    {
        "folke/which-key.nvim",
        opts = function(_, opts)
            opts["<leader>s"] = nil
            table.insert(opts.defaults, { ["<leader>t"] = { name = "+telescope" } })
            table.insert(opts.defaults, { ["<leader>tn"] = { name = "+noice" } })
        end,
    },
    {
        "echasnovski/mini.surround",
        opts = {
            mappings = {
                add = "sa",
                delete = "sd",
                find = "sf",
                find_left = "sF",
                highlight = "sh",
                replace = "sr",
                update_n_lines = "sn",
            },
        },
    },
}
