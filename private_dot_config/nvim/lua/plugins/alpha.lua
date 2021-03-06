local M = {}

M.alpha_load_fn = function ()
    local alpha = require'alpha'
    local dashboard = require'alpha.themes.dashboard'

    dashboard.section.header.val = {
        [[██╗     ███████╗███╗   ███╗ ██████╗ ███╗   ██╗██████╗  █████╗ ██╗   ██╗]],
        [[██║     ██╔════╝████╗ ████║██╔═══██╗████╗  ██║██╔══██╗██╔══██╗╚██╗ ██╔╝]],
        [[██║     █████╗  ██╔████╔██║██║   ██║██╔██╗ ██║██║  ██║███████║ ╚████╔╝ ]],
        [[██║     ██╔══╝  ██║╚██╔╝██║██║   ██║██║╚██╗██║██║  ██║██╔══██║  ╚██╔╝  ]],
        [[███████╗███████╗██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║   ]],
        [[╚══════╝╚══════╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ]],
    }

    dashboard.section.buttons.val = {
        dashboard.button( "n", "  New file" , ":ene <BAR> startinsert <CR>"),
        dashboard.button( "q", "  Quit NVIM" , ":qa<CR>"),
    }

    local handle = io.popen('fortune')
    local fortune = handle:read("*a")
    handle:close()
    dashboard.section.footer.val = fortune
    dashboard.config.opts.noautocmd = true
    vim.cmd[[autocmd User AlphaReady echo 'ready']]
    vim.cmd[[autocmd User AlphaReady set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2]]
    alpha.setup(dashboard.config)
end

return M
