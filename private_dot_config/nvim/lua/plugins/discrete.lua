vim.g.mkdp_auto_start = 1
vim.g.mkdp_refresh_slow = 1

-- system copy
local function cut_line()
    local r, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local _, lineContent = next(vim.api.nvim_buf_get_lines(0, r - 1, r, true))
    vim.cmd [[normal cP]]
    vim.api.nvim_buf_set_lines(0, r - 1, r, true, {})
    vim.notify('Cut line ' .. r .. ':' .. lineContent)
end

-- temp
vim.keymap.set('n', 'cX', cut_line, { noremap = true })
