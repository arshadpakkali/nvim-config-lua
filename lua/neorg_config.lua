require("neorg").setup({
    load = {
        ["core.defaults"] = {},
        ["core.export"] = {},
        ["core.export.markdown"] = {},
        ["core.norg.dirman"] = {
            config = {
                default_workspace = "home",
                workspaces = {
                    home = "~/Documents/Notes/",
                },
            },
        },
        ["core.norg.concealer"] = {
            config = {},
        },
        ["core.norg.completion"] = {
            config = {
                engine = "nvim-cmp",
            },
        },
    },
})
