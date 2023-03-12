local which_key = require("which-key")
local telescope = require("telescope.builtin")
local dap = require("dap")
local dapui = require("dapui")

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	-- operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local noremap_mappings = {
	["q"] = { "<cmd>q!<CR>", "Quit" },
	["F"] = { "<cmd>Rg<cr>", "Find Text" },
	["b"] = {
		name = "Buffer",
		b = { "<cmd>Buffers<cr>", "Buffers" },
		c = { "<cmd>Bdelete!<CR>", "Close Buffer" },
	},
	w = {
		q = { "<cmd>q!<CR>", "Quit" },
	},
	p = {
		name = "Packer",
		c = { "<cmd>PackerCompile<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		s = { "<cmd>PackerSync<cr>", "Sync" },
		S = { "<cmd>PackerStatus<cr>", "Status" },
		u = { "<cmd>PackerUpdate<cr>", "Update" },
		m = { "<cmd>Mason<cr>", "Mason" },
	},
	g = {
		name = "Git",
		g = { "<cmd>LazyGit<cr>", "Lazygit" },
		n = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
		p = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
		l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
		i = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		u = {
			"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
			"Undo Stage Hunk",
		},
		b = { "<cmd>G blame<cr>", "Checkout branch" },
		o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
		d = {
			"<cmd>Gitsigns diffthis HEAD<cr>",
			"Diff",
		},
	},
	l = {
		name = "LSP",
		a = {
			function()
				vim.lsp.buf.code_action()
			end,
			"Code Action",
		},
		d = {
			function()
				telescope.builtin.diagnostic()
			end,
			"Workspace Diagnostics",
		},
		f = {
			function()
				vim.lsp.buf.formatting()
			end,
			"Format",
		},
		i = { "<cmd>LspInfo<cr>", "Info" },
		n = {
			function()
				vim.lsp.diagnostic.goto_next()
			end,
			"Next Diagnostic",
		},
		p = {
			function()
				vim.lsp.diagnostic.goto_prev()
			end,
			"Prev Diagnostic",
		},
		l = {
			function()
				vim.lsp.codelens.run()
			end,
			"CodeLens Action",
		},

		L = { "<cmd>LspLog<cr>", "Lsp Log" },

		q = {
			function()
				vim.diagnostic.setqflist()
			end,
			"Quickfix",
		},

		r = {
			function()
				vim.lsp.buf.rename()
			end,
			"Rename",
		},

		["m"] = {
			function()
				telescope.lsp_document_symbols({ symbols = { "Method" } })
			end,
			"List All Methods In Document",
		},

		s = {
			function()
				telescope.lsp_document_symbols()
			end,
			"Document Symbols",
		},

		c = {
			"<cmd>source ~/.config/nvim/lua/luasnip_conf.lua",
		},
	},
	s = {
		name = "Search",
		b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
		M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		C = { "<cmd>Telescope commands<cr>", "Commands" },
	},
	t = {
		name = "toggle",
		d = { "<cmd>DBUIToggle<CR>", "Toggle DBUI" },
		j = { "<cmd>Neorg journal today<CR>", "Neorg journal" },
		c = { "<cmd>ColorizerToggle<CR>", "Toggle Colorizer" },
	},
}

if os.execute("git rev-parse &> /dev/null") == 0 then
	noremap_mappings[" "] = { ":GFiles --cached --others --exclude-standard<CR>", "Git Files" }
else
	noremap_mappings[" "] = { ":Files<CR>", "Files" }
end

local remap_opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = false, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local remap_mappings = {
	d = {
		name = "Debugger",
		d = {
			function()
				if vim.fn.filereadable(".vscode/Launch.json") then
					require("dap.ext.vscode").load_launchjs()
				end
				dap.continue()
				dapui.toggle()
			end,
			"Launch ",
		},

		q = {
			function()
				dap.disconnect()
				dapui.toggle()
			end,
			"Quit",
		},

		r = {
			function()
				dap.repl.toggle()
			end,
			"REPL toggle",
		},

		c = {
			function()
				dap.continue()
			end,
			"Continue",
		},

		j = {
			function()
				dap.step_out()
			end,
			"StepOut",
		},

		k = {
			function()
				dap.step_into()
			end,
			"StepInto",
		},

		l = {
			function()
				dap.step_over()
			end,
			"StepOver",
		},

		b = {
			function()
				dap.toggle_breakpoint()
			end,
			"Toggle Breakpoint",
		},

		-- ["B"] = { ":call vimspector#ToggleAdvancedBreakpoint()<CR> ", "Toggle Advanced Breakpoint" },

		["."] = {
			function()
				dap.run_to_cursor()
			end,
			"Run To Cursor",
		},

		x = {
			function()
				dap.clear_breakpoints()
			end,
			"clear all Breakpoints",
		},

		i = {
			function()
				require("dap.ui.widgets").hover()
			end,
			"Inspect",
		},

		["I"] = {
			function()
				require("dap.ui.widgets").preview()
			end,
			"Inspect",
		},
	},
}

which_key.setup(setup)
which_key.register(noremap_mappings, opts)
which_key.register(remap_mappings, remap_opts)
