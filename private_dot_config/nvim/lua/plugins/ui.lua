return {
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            opts.sections.lualine_y = {}
            opts.sections.lualine_z = {}
        end,
    },
    {
        "craftzdog/solarized-osaka.nvim",
        lazy = false,
        priority = 1000,
        opts = function()
            return {
                transparent = true,
            }
        end,
    },
    {
        "folke/noice.nvim",
        keys = {
            { "<leader>snl", false },
            {
                "<leader>tnl",
                function()
                    require("noice").cmd("last")
                end,
                desc = "Noice Last Message",
            },
            { "<leader>snh", false },
            {
                "<leader>tnh",
                function()
                    require("noice").cmd("history")
                end,
                desc = "Noice History",
            },
            { "<leader>sna", false },
            {
                "<leader>tna",
                function()
                    require("noice").cmd("all")
                end,
                desc = "Noice All",
            },
            { "<leader>snd", false },
            {
                "<leader>tnd",
                function()
                    require("noice").cmd("dismiss")
                end,
                desc = "Dismiss All",
            },
        },
    },
}
