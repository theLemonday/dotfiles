local M = {}

M.setup_fn = function(opts)
    opts.settings = {
        checkOnSave = {
            command = 'clippy'
        }
    }
end

return M
