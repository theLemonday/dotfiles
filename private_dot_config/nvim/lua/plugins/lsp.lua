local function findRoot(...)
    return require("lspconfig.util").root_pattern(".git")(...)
end

return {
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {
                "shfmt",
                "ansible-language-server",
                "svelte-language-server",
                "dockerfile-language-server",
                "yaml-language-server",
                "ansible-lint",
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "dockerfile",
                "fish",
                "svelte",
            },
        },
    },
    { "mfussenegger/nvim-ansible" },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                ansiblels = {
                    root_dir = findRoot(...),
                    settings = {
                        ansible = {
                            ansible = {
                                useFullyQualifiedCollectionNames = true,
                            },
                            python = {
                                interpreterPath = "python3",
                            },
                        },
                    },
                },
                gopls = {},
                tailwindcss = {
                    root_dir = findRoot(...),
                },
                tsserver = {
                    root_dir = findRoot(...),
                },
                -- yamlls = {
                --     settings = {
                --         yaml = {
                --             schemas = {
                --                 ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
                --                 ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] = "/*.ansible.yaml",
                --             },
                --         },
                --     },
                -- },
            },
        },
    },
}
