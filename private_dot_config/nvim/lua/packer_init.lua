local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', { command = 'source <afile> | PackerCompile', group = packer_group, pattern = 'init.lua' })

return require('packer').startup(function(use)
    --faster loading time
    use {'lewis6991/impatient.nvim', config = [[require('impatient')]]}

    -- pqg itself
    use 'savq/paq-nvim';

    -- greeting window
    use 'goolord/alpha-nvim';

    -- icon
    use 'kyazdani42/nvim-web-devicons';

    -- Show indent
    use 'lukas-reineke/indent-blankline.nvim';

    -- parenthesis
    use 'luochen1990/rainbow';

    -- Auto pair
    use 'windwp/nvim-autopairs';

    -- notification plugin
    use 'rcarriga/nvim-notify';

    -- tpope package
    -- comment
    use { 'numToStr/Comment.nvim' }

    use 'tpope/vim-repeat';
    use 'tpope/vim-surround';
    -- use 'tpope/vim-unimpaired';
    -- use 'tpope/vim-obsession';

    use 'Shatur/neovim-session-manager'

    -- highlight
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- file explorer
    use 'kyazdani42/nvim-tree.lua';

    -- file type
    use 'nathom/filetype.nvim'

    -- refactor
    use {
        "ThePrimeagen/refactoring.nvim",
        requires = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-treesitter/nvim-treesitter"}
        }
    }

    -- searching
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    };
    -- telescope extensions
    use 'nvim-telescope/telescope-media-files.nvim'
    use {'nvim-telescope/telescope-ui-select.nvim' }

    -- clipboard
    use {
        "AckslD/nvim-neoclip.lua",
        requires = {
            {'tami5/sqlite.lua', module = 'sqlite'},
            {'nvim-telescope/telescope.nvim'},
        },
        config = function()
            require('neoclip').setup()
        end,
    }
    -- use {
        --     'nvim-telescope/telescope-fzf-native.nvim',
        --     run = 'make'
        -- }

        -- color scheme
        use {'lifepillar/vim-gruvbox8', opt = true};
        use {'dracula/vim', opt = true};
        use {'navarasu/onedark.nvim'};
        -- colorizer
        use {'norcalli/nvim-colorizer.lua'}

        -- buffer line
        use {'akinsho/bufferline.nvim', tag = "*", requires = 'kyazdani42/nvim-web-devicons'};

        -- statusline
        use 'nvim-lualine/lualine.nvim'
        -- completion
        -- coq
        -- use {'ms-jpq/coq_nvim', branch='coq'};
        -- use {'ms-jpq/coq.artifacts', branch= 'artifacts'};
        -- use {'ms-jpq/coq.thirdparty', branch= '3p'};
        --
        -- cmp
        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'
        use 'hrsh7th/nvim-cmp'
        use 'hrsh7th/cmp-nvim-lua'
        use 'hrsh7th/cmp-calc'

        -- luasnip
        use 'L3MON4D3/LuaSnip'
        use 'saadparwaiz1/cmp_luasnip'

        -- lsp configuration
        use {
            'neovim/nvim-lspconfig', -- Collection of configurations for the built-in LSP client
            'williamboman/nvim-lsp-installer'
        }

        -- golang support
        use 'ray-x/go.nvim'

        -- cmake
        use 'cdelledonne/vim-cmake'

        -- terminal
        use {"akinsho/toggleterm.nvim"}

        -- Automatically set up your configuration after cloning packer.nvim
        -- Put this at the end after all plugins
        if packer_bootstrap then
            require('packer').sync()
            vim.cmd('autocmd User PaqDoneInstall quit')
        end
    end)
