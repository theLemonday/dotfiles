local util = require "lspconfig/util"
local M = {}

M.setup_fn = function(opts)
    opts.filetypes = { 'c', 'cpp' }
end

return M
