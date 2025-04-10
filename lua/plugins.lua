local fn = vim.fn

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"lewis6991/impatient.nvim",
	"unblevable/quick-scope",
	"norcalli/nvim-colorizer.lua",
	"mattn/emmet-vim",
	"kdheepak/lazygit.nvim",
	"tpope/vim-surround",
	"tpope/vim-fugitive",
	"L3MON4D3/LuaSnip",
	{
		"numToStr/Comment.nvim",
		opts = {},
	},
	{

		"folke/which-key.nvim",
		dependencies = {
			"echasnovski/mini.icons",
		},
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		config = function()
			require("gruvbox").setup({ contrast = "hard" })
			vim.cmd("let g:gruvbox_transparent_bg = 1")
			vim.cmd("autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE")
			vim.cmd("colorscheme gruvbox")
			vim.cmd("colorscheme gruvbox")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			scope = {
				enabled = false,
			},
		},
	},
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		ft = { "org" },
		config = function()
			-- Setup orgmode
			require("orgmode").setup({
				org_agenda_span = "day",
				org_agenda_files = { "~/Sync/**/*" },
				org_default_notes_file = "~/Sync/Tasks/refile.org",
				org_todo_keyword_faces = {
					TODO = ":background #000000 :foreground #F28B82 :weight bold :underline on", -- overrides builtin color for `TODO` keyword
					CANCELLED = ":background #000000 :foreground #6C757D :weight bold", -- overrides builtin color for `TODO` keyword
				},
				org_todo_keywords = { "TODO(t)", "|", "DONE(d)", "CANCELLED(c)" },
				org_capture_templates = {
					i = {
						description = "new Task (Inbox)",
						template = "* TODO %?\n:PROPERTIES:\n :CREATED: %u \n:END:",
					},
					t = {
						description = "new Task (Today)",
						template = "* TODO %?\n SCHEDULED: %t\n:PROPERTIES:\n :CREATED: %u \n:END:",
					},
					w = {
						description = "new Work Task (Today)",
						template = "* TODO %?\n:PROPERTIES:\n :CREATED: %u \n:END:",
						target = "/home/arshad/Sync/Tasks/work.org",
					},
					j = {
						description = "new Journal entry",
						target = "/home/arshad/Sync/journal/journal.org",
						datetree = { reversed = true },
					},
				},
			})
		end,
	},
	{
		"kyazdani42/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("lualine").setup({})
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	},
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		config = function()
			require("fidget").setup({})
		end,
	},
	{
		"onsails/lspkind.nvim",
		config = function()
			require("lspkind").init()
		end,
	},
	{
		"kyazdani42/nvim-tree.lua",
		dependencies = {
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				on_attach = require("nvimtree_config"),
				view = {
					width = 45,
				},
				update_focused_file = {
					enable = true,
					update_root = false,
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"hrsh7th/nvim-cmp",
				dependencies = {
					{
						"MattiasMTS/cmp-dbee",
						dependencies = {
							{ "kndndrj/nvim-dbee" },
						},
						ft = "sql", -- optional but good to have
						opts = {}, -- needed
					},
				},
			},
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-calc",
			"saadparwaiz1/cmp_luasnip",
			"jose-elias-alvarez/null-ls.nvim",
			"ray-x/lsp_signature.nvim",
			"b0o/schemastore.nvim",
			"folke/neodev.nvim",
			"L3MON4D3/LuaSnip",
			"rcarriga/cmp-dap",
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			{ "nvim-telescope/telescope-frecency.nvim", dependencies = { "kkharji/sqlite.lua" } },
			{
				"prochri/telescope-all-recent.nvim",
			},
		},
		config = function()
			local telescopeActions = require("telescope.actions")

			require("telescope").setup({
				defaults = {
					layout_strategy = "flex",
					mappings = {
						i = {
							["<Esc>"] = telescopeActions.close,
							["<C-u>"] = false,
						},
					},
				},
			})
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("frecency")
			require("telescope-all-recent").setup({})
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-treesitter/nvim-treesitter-context",
		},
		build = ":TSUpdate",
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
	},
	{
		"digitaltoad/vim-pug",
	},
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"kndndrj/nvim-dbee",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		build = function()
			-- Install tries to automatically detect the install method.
			-- if it fails, try calling it with one of these parameters:
			--    "curl", "wget", "bitsadmin", "go"
			require("dbee").install()
		end,
		config = function()
			require("dbee").setup({
				sources = {
					require("dbee.sources").MemorySource:new({
						{
							name = "Uphabit Prod RO",
							type = "postgres", -- type of database driver
							url = "postgresql://arshad:qasda3412!234@localhost:5431/uphabit_prod",
						},
						{
							name = "local uphabit Postgres",
							type = "postgres", -- type of database driver
							url = "postgresql://postgres:postgres@localhost:5432/uh_prod_copy",
						},
						{
							name = "Staging uphabit Postgres",
							type = "postgres", -- type of database driver
							url = "postgresql://uphabit:CFGElIIvgwOnSpm4N7gv@localhost:5430/uphabit_development?sslmode=disable",
						},
					}),
				},
			})
		end,
	},
	"prisma/vim-prisma",
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				rust = { "rustfmt", lsp_format = "fallback" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				json5 = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},

	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
			}
			vim.api.nvim_create_autocmd({ "TextChanged", "BufWritePost", "InsertLeave" }, {
				callback = function()
					-- try_lint without arguments runs the linters defined in `linters_by_ft`
					-- for the current filetype
					require("lint").try_lint()
				end,
			})
		end,
	},
	{
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup({
				-- optionally use on_attach to set keymaps when aerial has attached to a buffer
				on_attach = function(bufnr)
					-- Jump forwards/backwards with '{' and '}'
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			})
		end,
	},
})
