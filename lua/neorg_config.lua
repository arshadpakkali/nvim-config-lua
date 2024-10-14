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
					example_gtd = "~/Documents/Code/personal",
					uphabit = "~/Documents/Code/uphabit/notes",
					clinook = "~/Documents/Code/clinook_new/notes",
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
