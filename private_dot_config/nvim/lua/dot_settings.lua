local o = vim.o
local wo = vim.wo
local bo = vim.bo
local g = vim.g
local cmd = vim.cmd
local util = require('utils')

local status, _ = pcall(require, 'packer_compiled')
if status then
    vim.notify("Packer compile finished")
else
    vim.notify("Error requiring packer_compiled.lua: run PackerSync to fix!")
end

-- general setting
o.mouse = 'a' -- mouse support in all mode
o.signcolumn = 'no' -- left sign column
o.termguicolors = true -- 24 bit color support
cmd("autocmd BufWinEnter,WinEnter term://* startinsert") -- Start by enter enter insert mode
-- For Window [[autocmd BufWritePost,FileWritePost * silent ! attrib +h <afile>~]]
cmd [[autocmd BufWritePost,FileWritePost * silent ! mv <afile>~ .<afile>]]

-- indentation
o.autoindent = true
o.smartindent = true

-- tab
o.expandtab = true
o.shiftwidth = 4 -- tab = 4 spaces

-- wrap
o.wrap = true -- enable wrap line
o.textwidth = 120 -- wrap line at 120 chars
o.linebreak = true -- avoid wrap line breaking the word

-- braces
o.showmatch = true

--syntax
o.syntax = 'on'
o.syntax = 'enable' -- enable syntax

--number
o.number = true
o.relativenumber = true
cmd ("autocmd InsertEnter * :set norelativenumber")
cmd ("autocmd InsertLeave * :set relativenumber")

-- command
o.showcmd = true
o.wildmenu = true
o.cmdheight = 2 -- number of line for command line

-- update screen
o.lazyredraw = true -- dont update screen during macro and script execution

-- on screen 
o.encoding = 'utf-8' -- encoding
o.scrolloff = 3 -- number of line above and below cursor
o.sidescrolloff = 5 -- same but with column
o.cursorline = true -- hi current cursor line
o.title = false -- display window title
o.hidden = true -- hidden the buffer when abandon
g.t_Co = '256' -- set color range 256

-- backup files
o.swapfile = false
o.backup = true -- use back up file
o.writebackup = false

-- load files
o.autoread = true -- re read the file if not modified in vim
o.history = 1000 -- undo limit


--	          _                       _                         
--	         | |                     | |                        
--	 ___ ___ | | ___  _ __   ___  ___| |__   ___ _ __ ___   ___ 
--	/ __/ _ \| |/ _ \| '__| / __|/ __| '_ \ / _ \ '_ ` _ \ / _ \
--	 (_| (_) | | (_) | |    \__ \ (__| | | |  __/ | | | | |  __/
--	\___\___/|_|\___/|_|    |___/\___|_| |_|\___|_| |_| |_|\___|
--colorscheme	

--o.background = 'dark'
cmd "colorscheme gruvbox8"
--cmd "hi Normal guibg=NONE ctermbg=NONE" -- transparent background
o.guifont="Hack Nerd Font 11"
