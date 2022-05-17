local dropbox_path
if vim.fn.has 'wsl' == 1 then
    dropbox_path = '/mnt/c/Users/nhath/Dropbox/'
else
    dropbox_path = '~/Dropbox/'
end

local org_mode_glob_path = {
    org_agenda_files = { dropbox_path .. 'org/*', '~/org_mode/**/*' },
    org_default_notes_file = dropbox_path .. 'org/refile.org',
}

require('orgmode').setup(org_mode_glob_path)
