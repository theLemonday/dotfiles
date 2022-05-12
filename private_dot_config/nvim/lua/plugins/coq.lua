vim.g.coq_settings = {
    auto_start = 'shut-up',
    -- ["keymap.repeat"] = '.',
}

require("coq_3p") {
    { src = "bc", short_name = "MATH", precision = 6 },
    { src = "figlet", short_name = "big", triggler = "!figlet"},
    { src = "nvimlua", short_name = "nLUA", conf_only = true },
}
