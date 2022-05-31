local keymap = vim.keymap
local Terminal = require('toggleterm.terminal').Terminal

-- Terminal:new {
--   cmd = string -- command to execute when creating the terminal e.g. 'top'
--   direction = string -- the layout for the terminal, same as the main config options
--   dir = string -- the directory for the terminal
--   close_on_exit = bool -- close the terminal window when the process exits
--   highlights = table -- a table with highlights
--   env = table -- key:value table with environmental variables passed to jobstart()
--   clear_env = bool -- use only environmental variables from `env`, passed to jobstart()
--   on_open = fun(t: Terminal) -- function to run when the terminal opens
--   on_close = fun(t: Terminal) -- function to run when the terminal closes
--   -- callbacks for processing the output
--   on_stdout = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stdout
--   on_stderr = fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr
--   on_exit = fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
-- }
local rustBuildTerminal = Terminal:new {
    cmd = 'cargo build',
}

require('filetype').setup {
    overrides = {
        chn = 'org',
    },
    literal = {
        ['生词'] = 'org',
    },
    function_extensions = {
        ['rs'] = function()
            vim.bo.filetype = 'rust'
            keymap.set('n', '<F33>', function()
                rustBuildTerminal:toggle(30, 'tab')
            end, { noremap = true, silent = true })
        end,
        ['lua'] = function()
            keymap.set('n', '<F2>', function()
                print 'hello'
            end, { noremap = true })
        end,
    },
}
