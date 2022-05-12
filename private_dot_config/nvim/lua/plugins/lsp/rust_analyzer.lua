local M = {}

M.set_fn = function(opts)
    opts.settings = {
        checkOnSave = {
            command = 'clippy'
        }
    }
end

return M
