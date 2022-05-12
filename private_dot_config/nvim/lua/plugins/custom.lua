local util = require "utils.util"

local M = {}

local function trim(s)
  -- from PiL2 20.4
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function insert(text)
    vim.api.nvim_buf_set_lines(0, -2, -2, false, text)
end

local function check(text, toCheck)
    return string.sub(text, 0, string.len(toCheck)) == toCheck
end

local function concatArray(a, b)
    for _, v in ipairs(b) do
        table.insert(a, v)
    end
    return a
end

--private long hello;
function M.test()
    require'notify''Insert getter and setter'
    local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local toInsert = {}
    for _, i in ipairs(content) do
        local private = "private"
        local text = trim(i)
        if check(text, private) and string.sub(text, string.len(text), string.len(text)) == ";" then
            local temp = string.sub(text, string.len(private) + 2, string.len(text) - 1)
            print(temp)
            local type_word, name = string.match(temp, "(.*) (.*)")
            if name ~= string.upper(name) then
                local get = {
                    "\tpublic " .. type_word .. " get" .. string.upper(string.sub(name, 0, 1)) .. string.sub(name, 2, string.len(name)) .. " () {",
                    "\t\treturn " .. name .. ";",
                    "\t}",
                    ""
                }
                toInsert = concatArray(toInsert, get)

                local set = {
                    "\tpublic void set" .. string.upper(string.sub(name, 0, 1)) .. string.sub(name, 2, string.len(name)) .. " (" .. type_word .. " " .. name .. ") {",
                    "\t\treturn this." .. name .. " = " .. name .. ";",
                    "\t}",
                    ""
                }
                toInsert = concatArray(toInsert, set)
            end
        end
    end
    insert(toInsert)
end

util.map("n", "<M-n>", "<cmd>lua require'plugins.custom'.test()<cr>", {noremap = true})

return M
