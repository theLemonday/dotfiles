return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "shfmt",
        "ansible-language-server",
        "svelte-language-server",
        "dockerfile-language-server",
      })
    end,
  },
}
