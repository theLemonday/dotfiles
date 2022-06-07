local fn = vim.fn

local function conf(name)
    return require(string.format('plugins.%s', name))
end

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd(
    'BufWritePost',
    { command = 'source <afile> | PackerCompile', group = packer_group, pattern = 'init.lua' }
)

local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system {
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path,
    }
end

return require('packer').startup(function(use)
    --faster loading time
    use { 'lewis6991/impatient.nvim', config = [[require('impatient')]] }

    use 'wbthomason/packer.nvim'

    -- icon
    use {
        'kyazdani42/nvim-web-devicons',
        requires = {
            { 'akinsho/bufferline.nvim', tag = '*' },
            { 'kyazdani42/nvim-tree.lua', tag = 'nightly' },
        },
    }

    -- statusline
    use 'nvim-lualine/lualine.nvim'

    -- Show indent
    use 'lukas-reineke/indent-blankline.nvim'

    -- notification plugin
    use {
        'rcarriga/nvim-notify',
        config = function()
            vim.notify = require 'notify'
        end,
    }

    use { -- Comment
        'numToStr/Comment.nvim',
        'LudoPinelli/comment-box.nvim',
    }

    use 'christoomey/vim-system-copy'
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'rmagatti/auto-session'
    use 'jiangmiao/auto-pairs'

    -- highlight
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        requires = {
            'beauwilliams/focus.nvim',
            'p00f/nvim-ts-rainbow', -- parentheses rainbow
            'JoosepAlviste/nvim-ts-context-commentstring',
            'SmiteshP/nvim-gps',
        },
    }

    -- refactor
    use {
        'ThePrimeagen/refactoring.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-treesitter/nvim-treesitter' },
        },
    }

    use { -- telescope
        'nvim-telescope/telescope.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-media-files.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        },
    }

    use { -- color
        'lifepillar/vim-gruvbox8',
        'navarasu/onedark.nvim',
        'norcalli/nvim-colorizer.lua',
        'xiyaowong/nvim-transparent',
        'folke/tokyonight.nvim',
        'Mofiqul/dracula.nvim',
    }

    use { -- coq
        'ms-jpq/coq_nvim',
        branch = 'coq',
        requires = {
            { 'ms-jpq/coq.artifacts', branch = 'artifacts' },
            { 'ms-jpq/coq.thirdparty', branch = '3p' },
        },
    }

    -- lsp configuration
    use {
        'neovim/nvim-lspconfig', -- Collection of configurations for the built-in LSP client
        requires = {
            'williamboman/nvim-lsp-installer', -- auto install lsp
            'kosayoda/nvim-lightbulb',
        },
    }

    use {
        'filipdutescu/renamer.nvim',
        branch = 'master',
        requires = 'nvim-lua/plenary.nvim',
    }

    -- golang support
    -- use 'ray-x/go.nvim'

    -- signature
    use 'ray-x/lsp_signature.nvim'

    use { -- Rust
        'simrat39/rust-tools.nvim',
        ft = 'rust',
    }

    -- cmake
    -- use 'cdelledonne/vim-cmake'

    -- format
    use 'mhartington/formatter.nvim'

    -- terminal
    use 'akinsho/toggleterm.nvim'

    -- ctags
    use 'preservim/tagbar'

    -- multi cursor
    use { 'mg979/vim-visual-multi', branch = 'master' }

    use { -- oRG mode
        'nvim-orgmode/orgmode',
        {
            'akinsho/org-bullets.nvim',
            config = function()
                require('org-bullets').setup {
                    symbols = { '◉', '○', '✸', '✿' },
                }
            end,
            ft = 'org',
        },
        'dhruvasagar/vim-table-mode',
    }

    use { -- language utils
        'iamcco/markdown-preview.nvim',
        run = 'cd app && npm install',
        config = conf 'mkdp',
        ft = 'markdown',
    }

    use { -- utilities
        {
            'lewis6991/gitsigns.nvim',
            tag = 'release',
            config = conf 'gitsigns',
        },
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
