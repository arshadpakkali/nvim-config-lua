require("neorg").setup({
	load = {
		["core.defaults"] = {},
		["core.export"] = {},
		["core.export.markdown"] = {},
		["core.dirman"] = {
			config = {
				default_workspace = "home",
				workspaces = {
					home = "~/Documents/Notes/",
				},
			},
		},
		["core.concealer"] = {
			config = {},
		},
		["core.completion"] = {
			config = {
				engine = "nvim-cmp",
			},
		},
	},
})
