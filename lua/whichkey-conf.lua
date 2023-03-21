local which_key = require("which-key")
local telescope_builtin = require("telescope.builtin")
local dap = require("dap")

local noremap_opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local noremap_mappings = {
	["q"] = {
		name = "Quit",
		a = {
			"<cmd>qa",
			"Quit All",
		},
	},
	["F"] = {
		function()
			telescope_builtin.live_grep()
		end,
		"Find Text",
	},
	["b"] = {
		name = "Buffer",
		b = {
			function()
				telescope_builtin.buffers()
			end,
			"Buffers",
		},
		c = { "<cmd>bc<CR>", "Close Buffer" },
		n = { "<cmd>bn<CR>", "Prev Buffer" },
		p = { "<cmd>bp<CR>", "Next Buffer" },
	},
	p = {
		name = "Plugins",
		s = {
			function()
				require("lazy").sync()
			end,
			"Sync",
		},
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
				telescope_builtin.diagnostic()
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
				telescope_builtin.lsp_document_symbols({ symbols = { "Method" } })
			end,
			"List All Methods In Document",
		},
		s = {
			function()
				telescope_builtin.lsp_document_symbols()
			end,
			"Document Symbols",
		},
		c = {
			"<cmd>source ~/.config/nvim/lua/luasnip_conf.lua",
		},
	},
	s = {
		name = "Search",
		f = {
			function()
				telescope_builtin.find_files()
			end,
			"Find Files",
		},
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
		q = {
			function()
				vim.cmd("copen")
			end,
			"Open Quickfix",
		},
		j = { "<cmd>Neorg journal today<CR>", "Open Neorg journal" },
		d = { "<cmd>DBUIToggle<CR>", "Toggle DBUI" },
		c = { "<cmd>ColorizerToggle<CR>", "Toggle Colorizer" },
	},
}

if os.execute("git rev-parse &> /dev/null") == 0 then
	noremap_mappings[" "] = {
		function()
			telescope_builtin.git_files({
				git_command = { "git", "ls-files", "--cached", "--others", "--exclude-standard" },
			})
		end,
		"Git Files",
	}
else
	noremap_mappings[" "] = {
		function()
			telescope_builtin.find_files()
		end,
		"Files",
	}
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
			end,
			"Launch ",
		},
		q = {
			function()
				dap.terminate()
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
		e = {
			function()
				dap.set_exception_breakpoints()
			end,
			"set Exception Breakpoints",
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

which_key.setup()
which_key.register(noremap_mappings, noremap_opts)
which_key.register(remap_mappings, remap_opts)
