local keymap = vim.keymap
local lspconfig = require 'lspconfig'
local lsp_installer = require 'nvim-lsp-installer'

local map_opts = {
    noremap = true,
    silent = true,
}
keymap.set('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', map_opts)
keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', map_opts)
keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', map_opts)
keymap.set('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', map_opts)

-- list of servers
local servers = {
    'sumneko_lua',
    'gopls',
    'clangd',
    'cmake',
    'rust_analyzer',
}

lsp_installer.setup {
    ensure_installed = servers,
    -- automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
}

local function on_attach(_, bufnr)
    local map_opt = {
        noremap = true,
        silent = true,
        buffer = bufnr,
    }
    -- Mappings.
    keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', map_opt)
    keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', map_opt)
    keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', map_opt)
    keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', map_opt)
    keymap.set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', map_opt)
    keymap.set('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', map_opt)
    keymap.set('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', map_opt)
    keymap.set('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', map_opt)
    keymap.set('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', map_opt)
    keymap.set('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', map_opt)
    keymap.set('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', map_opt)
    keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', map_opt)
    keymap.set('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', map_opt)
end

-- coq setup
vim.g.coq_settings = {
    auto_start = 'shut-up',
    display = {
        icons = {
            mode = 'long',
            mappings = {
                Text = '',
                Method = '',
                Function = '',
                Constructor = '',
                Field = '',
                Variable = '',
                Class = 'ﴯ',
                Interface = '',
                Module = '',
                Property = 'ﰠ',
                Unit = '',
                Value = '',
                Enum = '',
                Keyword = '',
                Snippet = '',
                Color = '',
                File = '',
                Reference = '',
                Folder = '',
                EnumMember = '',
                Constant = '',
                Struct = '',
                Event = '',
                Operator = '',
                TypeParameter = '',
            },
        },
        pum = {
            fast_close = false,
        },
    },
}

local coq = require 'coq'
for _, lsp in ipairs(servers) do
    local opts = {
        on_attach = on_attach,
    }

    require('plugins.lsp.' .. lsp).setup_fn(opts)

    lspconfig[lsp].setup(coq.lsp_ensure_capabilities(opts))
end

require 'coq_3p' {
    { src = 'nvimlua', short_name = 'nLUA', conf_only = true },
}

-- lsp signature
require('lsp_signature').setup {
    floating_window = false,
}
