local util = require'utils.util'

require("toggleterm").setup {
    -- size can be a number or function which is passed the current terminal
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
        end
    end,
    -- open_mapping = [[<Esc>]],
    hide_numbers = true -- hide the number column in toggleterm buffers
}

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<leader>t', [[<cmd>ToggleTerm<cr>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
util.map('n', '<leader>t', '<cmd>ToggleTerm<cr>', {noremap = true, silent = true})
--   on_open = fun(t: Terminal), -- function to run when the terminal opens
--   on_close = fun(t: Terminal), -- function to run when the terminal closes
--   on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
--   on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
--   on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
--   shade_filetypes = {},
--   highlights = {
    --     -- highlights which map to a highlight group name and a table of it's values
    --     -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
    --     Normal = {
        --       guibg = <VALUE-HERE>,
        --     },
        --     NormalFloat = {
            --       link = 'Normal'
            --     },
            --     FloatBorder = {
                --       guifg = <VALUE-HERE>,
                --       guibg = <VALUE-HERE>,
                --     },
                --   },
                --   shade_terminals = true,
                --   shading_factor = '<number>', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
                --   start_in_insert = true,
                --   insert_mappings = true, -- whether or not the open mapping applies in insert mode
                --   terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
                --   persist_size = true,
                --   direction = 'vertical' | 'horizontal' | 'tab' | 'float',
                --   close_on_exit = true, -- close the terminal window when the process exits
                --   shell = vim.o.shell, -- change the default shell
                --   -- This field is only relevant if direction is set to 'float'
                --   float_opts = {
                    --     -- The border key is *almost* the same as 'nvim_open_win'
                    --     -- see :h nvim_open_win for details on borders however
                    --     -- the 'curved' border is a custom border type
                    --     -- not natively supported but implemented in this plugin.
                    --     border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
                    --     width = <value>,
                    --     height = <value>,
                    --     winblend = 3,
                    --   }
