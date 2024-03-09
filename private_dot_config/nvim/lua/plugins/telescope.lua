local Util = require("lazyvim.util")

local keys = {
    { "<leader>s", false },
    { '<leader>s"', false },
    { "<leader>sa", false },
    { "<leader>sb", false },
    { "<leader>sc", false },
    { "<leader>sC", false },
    { "<leader>sd", false },
    { "<leader>sD", false },
    { "<leader>sg", false },
    { "<leader>sG", false },
    { "<leader>sh", false },
    { "<leader>sH", false },
    { "<leader>sk", false },
    { "<leader>sM", false },
    { "<leader>sm", false },
    { "<leader>so", false },
    { "<leader>sR", false },
    { "<leader>sw", false },
    { "<leader>sW", false },

    { '<leader>t"', "<cmd>Telescope registers<cr>", desc = "Registers" },
    { "<leader>ta", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
    { "<leader>tb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
    { "<leader>tc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader>tC", "<cmd>Telescope commands<cr>", desc = "Commands" },
    { "<leader>td", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
    { "<leader>tD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
    { "<leader>tg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
    { "<leader>tG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
    { "<leader>th", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
    { "<leader>tH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
    { "<leader>tk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
    { "<leader>tM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    { "<leader>tm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
    { "<leader>to", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    { "<leader>tR", "<cmd>Telescope resume<cr>", desc = "Resume" },
    { "<leader>tw", Util.telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
    { "<leader>tW", Util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
    { "<leader>tw", Util.telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
    { "<leader>tW", Util.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
    { "<leader>ss", false },
    {
        "<leader>fs",
        function()
            require("telescope.builtin").lsp_document_symbols({
                symbols = require("lazyvim.config").get_kind_filter(),
            })
        end,
        desc = "Goto Symbol",
    },
    { "<leader>sS", false },
    {
        "<leader>fS",
        function()
            require("telescope.builtin").lsp_dynamic_workspace_symbols({
                symbols = require("lazyvim.config").get_kind_filter(),
            })
        end,
        desc = "Goto Symbol (Workspace)",
    },
}

return {
    {
        "nvim-pack/nvim-spectre",
        keys = {
            { "<leader>sr", false },
            {
                "<leader>tr",
                function()
                    require("spectre").open()
                end,
                desc = "Replace in files (Spectre)",
            },
        },
    },
    {
        "folke/todo-comments.nvim",
        keys = {
            { "<leader>st", false },
            { "<leader>tt", "<cmd>TodoTelescope<cr>", desc = "Todo" },
            { "<leader>sT", false },
            { "<leader>tT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
        },
    },
    {
        "nvim-telescope/telescope.nvim",
        keys = keys,
    },
}
