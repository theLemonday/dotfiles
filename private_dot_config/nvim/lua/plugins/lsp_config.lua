local util = require('utils.util')
local lsp_installer = require "nvim-lsp-installer"
local notify = require'notify'

-- More on `:help vim.diagnostic.*`
local map_opts = {
    noremap=true,
    silent=true
}
util.map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', map_opts)
util.map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', map_opts)
util.map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', map_opts)
util.map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', map_opts)

-- list of servers
local servers = {
    'sumneko_lua',
    'gopls',
    'clangd',
    'cmake',
    'rust_analyzer',
}

for _, name in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found and not server:is_installed() then
        notify('Installing ' .. name .. ' server')
        server:install()
    end
end

local function on_attach(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    -- util.map_buf(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- More on `:help vim.lsp.*`
    util.map_buf(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', map_opts)
    util.map_buf(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', map_opts)
    util.map_buf(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', map_opts)
    util.map_buf(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', map_opts)
    util.map_buf(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', map_opts)
    util.map_buf(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', map_opts)
    util.map_buf(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', map_opts)
    util.map_buf(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', map_opts)
    util.map_buf(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', map_opts)
    util.map_buf(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', map_opts)
    util.map_buf(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', map_opts)
    util.map_buf(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', map_opts)
    util.map_buf(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', map_opts)
end


local enhance_server_opts = {
    -- Provide settings that should only apply to the "eslint" server
    ["eslint"] = function(opts)
        opts.settings = {
            format = {
                enable = true,
            },
        }
    end,
}

for _, v in ipairs(servers) do
    enhance_server_opts[v] = require("plugins.lsp." .. v).setup_fn
end

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp_installer.on_server_ready(function(server)
    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
    }

    if enhance_server_opts[server.name] then
        enhance_server_opts[server.name](opts)
    end

    server:setup(opts)
end)
