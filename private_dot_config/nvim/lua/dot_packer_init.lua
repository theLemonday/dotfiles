local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
    --faster loading time
    use 'lewis6991/impatient.nvim';

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
    use 'tpope/vim-commentary';
    use 'tpope/vim-repeat';
    use 'tpope/vim-surround';
    -- use 'tpope/vim-unimpaired';
    use 'tpope/vim-obsession';

    -- highlight
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- file explorer
    use 'kyazdani42/nvim-tree.lua';

    -- searching
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    };

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
    use {'navarasu/onedark.nvim', opt = true};

    -- buffer line
    use {'akinsho/bufferline.nvim', tag = "*", requires = 'kyazdani42/nvim-web-devicons'};

    -- completion
    use {'ms-jpq/coq_nvim', branch='coq'};
    use {'ms-jpq/coq.artifacts', branch= 'artifacts'};
    use {'ms-jpq/coq.thirdparty', branch= '3p'};

    -- lsp configuration
    use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client

    -- golang support
    use 'ray-x/go.nvim'

    -- terminal
    use {
    's1n7ax/nvim-terminal',
    config = function()
        vim.o.hidden = true
        require('nvim-terminal').setup()
    end,
}

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
