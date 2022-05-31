local M = {}

M.setup_fn = function(opts)
    opts.settings = {
        assist = {
            importGranularity = 'module',
            importPrefix = 'self',
        },
        cargo = {
            loadOutDirsFromCheck = true,
        },
        procMacro = {
            enable = true,
        },
        checkOnSave = {
            command = 'clippy',
        },
    }
end

return M
