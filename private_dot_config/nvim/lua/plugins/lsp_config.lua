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
    'dockerls',
    'clangd',
    'cmake',
    'rust_analyzer',
    'vuels',
    'eslint',
    'html',
}

lsp_installer.setup {
    ensure_installed = servers,
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
            mappings = require('symbols').icons_set,
        },
        pum = {
            fast_close = false,
        },
    },
    keymap = {
        recommended = false,
        jump_to_mark = '<C-j>',
        eval_snips = '<tab>',
        pre_select = true,
    },
}

local coq_map_opts = { expr = true, noremap = true }
keymap.set('i', '<esc>', [[pumvisible() ? "<c-e><esc>" : "<esc>"]], { expr = true, noremap = true })
keymap.set('i', '<c-c>', [[pumvisible() ? "<c-e><c-c>" : "<c-c>"]], { expr = true, noremap = true })
keymap.set('i', '<bs>', [[pumvisible() ? "\<C-e><BS>"  : "\<BS>"]], coq_map_opts)
keymap.set(
    'i',
    '<CR>',
    [[pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"]],
    coq_map_opts
)
keymap.set('i', '<tab>', [[pumvisible() ? "<c-n>" : "<tab>"]], { expr = true, noremap = true })
keymap.set('i', '<s-tab>', [[pumvisible() ? "<c-p>" : "<bs>"]], { expr = true, noremap = true })

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
    { src = 'orgmode', short_name = 'oRG' },
}

-- lsp signature
require('lsp_signature').setup {
    bind = true,
    handler_opts = {
        border = 'none', -- double, rounded, single, shadow, none
    },
    floating_window = true,
    floating_window_above_cur_line = true,
    doc_lines = 0,
}

require('nvim-lightbulb').setup { autocmd = { enabled = true } }

--vim.g.vista.renderer.enable_icon = 1
--vim.g.vista#renderer
-- vim.cmd[[let g:vista#renderer#enable_icon = 1]]

return M
