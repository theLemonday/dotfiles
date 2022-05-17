require 'plugins.auto_pair'
require 'plugins.bufferline'
require 'plugins.color'
require 'plugins.custom'
require 'plugins.format'
require 'plugins.indent_blankline'

-- file related
require 'plugins.nvim-treesister'
require 'plugins.filetype'
require 'plugins.org_mode'

require 'plugins.nvim_tree'
require 'plugins.session'
require 'plugins.startup'
require 'plugins.statusline'
require 'plugins.telescope'
require 'plugins.terminal'
require 'plugins.lsp_config'

local icons = require 'nvim-nonicons'
icons.get 'file'

require('Comment').setup()
