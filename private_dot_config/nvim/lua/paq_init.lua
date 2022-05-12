PKGS =  {
    --faster loading time
    'lewis6991/impatient.nvim';

    -- pqg itself
    "savq/paq-nvim";

    -- greeting window
    'goolord/alpha-nvim';
    'kyazdani42/nvim-web-devicons';
    
    -- Show indent 
    'lukas-reineke/indent-blankline.nvim';

    -- parenthesis
    'luochen1990/rainbow';

    -- Auto pair
    'windwp/nvim-autopairs';

    -- notification plugin
    'rcarriga/nvim-notify';
      
    -- tpope package
    'tpope/vim-commentary';
    'tpope/vim-repeat';
    'tpope/vim-surround';
    'tpope/vim-unimpaired';
    'tpope/vim-obsession';

    -- file explorer
    'kyazdani42/nvim-tree.lua';

    -- color scheme
    {"lifepillar/vim-gruvbox8", opt = true};
    {"dracula/vim", opt = true};
    -- {'Pocco81/Catppuccin.nvim', opt = true};
    {'navarasu/onedark.nvim', opt = true};
}

local function load_paq()
    vim.cmd('packadd paq-nvim')
    local paq = require('paq')
end

-- install paq if not found
local path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if vim.fn.empty(vim.fn.glob(path)) > 0 then 
    require('bootstrap').clone_paq(path) 

    load_paq()
    -- Exit nvim after installing plugins
    vim.cmd('autocmd User PaqDoneInstall quit')
    paq(PKGS)
    paq.install()
end

require'paq' (PKGS)
require'plugins.general'
