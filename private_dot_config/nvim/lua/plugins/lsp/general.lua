local util = require("utils.util")
local M = {}


M.setup = {
    on_attach = on_attach,
    flags = {
        -- This will be the default in neovim 0.7+
        debounce_text_changes = 150,
    }
}

return M
