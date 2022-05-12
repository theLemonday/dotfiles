require('onedark').setup {
    style = 'deep'
}
require('onedark').load()

--colorizer
require'colorizer'.setup (
    -- specific
    {
        '*',
    },
    --default
    {
        css = true,
        css_fn = true,
    }
)
