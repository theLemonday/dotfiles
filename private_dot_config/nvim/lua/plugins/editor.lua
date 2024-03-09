local Util = require("lazyvim.util")
local lazyterm = function()
    Util.terminal(nil, { cwd = Util.root() })
end

return {
    {
        "folke/which-key.nvim",
        opts = {
            defaults = {
                ["<leader>s"] = nil,
                ["<leader>tn"] = { name = "+noice" },
                ["<leader>t"] = { name = "+telescope/terminal" },
                ["<leader>tg"] = {
                    function()
                        Util.terminal("lazygit")
                    end,
                    "Lazygit",
                },
            },
        },
        -- } function(_, opts)
        -- opts
        -- table.insert(opts.defaults, {  })
        -- table.insert(opts.defaults, {  })
        -- end,
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
