-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
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
			require("gruvbox").setup({ terminal_colors = true, contrast = "hard" })
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
		dependencies = {
			"akinsho/org-bullets.nvim",
		},
		config = function()
			-- Setup orgmode
			require("orgmode").setup({
				org_agenda_span = "day",
				org_agenda_files = { "~/Documents/orgfiles/**/*" },
				org_default_notes_file = "~/Documents/orgfiles/refile.org",
				org_agenda_skip_scheduled_if_done = true,
				org_todo_keyword_faces = {
					TODO = ":background #000000 :foreground #F28B82 :weight bold :underline on", -- overrides builtin color for `TODO` keyword
					CANCELLED = ":background #000000 :foreground #6C757D :weight bold", -- overrides builtin color for `TODO` keyword
				},
				org_todo_keywords = { "TODO(t)", "WAITING(w)", "|", "DONE(d)", "CANCELLED(c)" },
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
						template = "* TODO %?  :work:\n SCHEDULED: %t\n:PROPERTIES:\n :CREATED: %u \n:END:",
						target = "~/Documents/orgfiles/work.org",
					},
					j = {
						description = "new Journal entry",
						target = "~/Documents/orgfiles/journal.org",
						datetree = { reversed = true },
					},
				},
				org_agenda_custom_commands = {
					w = {
						description = "Work Items",
						types = {
							{
								type = "agenda",
								org_agenda_tag_filter_preset = "work",
								org_agenda_overriding_header = "All work items",
							},
						},
					},
				},
			})
			require("org-bullets").setup()
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
			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})
			require("mason-lspconfig").setup({
				automatic_installation = true,
				ensure_installed = { "" },
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
						opts = function(_, opts)
							opts.sources = opts.sources or {}
							table.insert(opts.sources, {
								name = "lazydev",
								group_index = 0, -- set group index to 0 to skip loading LuaLS completions
							})
						end,
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
					require("dbee.sources").MemorySource:new({}),
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
				yaml = { "prettierd", "prettier", stop_after_first = true },
				sql = { "sqlfmt" },
				sh = { "shfmt" },
				cs = { "csharpier" },
			},
			formatters = {
				["csharpier"] = {
					command = "csharpier",
					args = { "format", "--write-stdout" },
					stdin = true,
				},
			},
		},
	},

	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				typescript = { "eslint_d" },
				typescriptreact = { "eslint_d" },
				javascript = { "eslint_d" },
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
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		opts = {},
	},
	{
		"seblyng/roslyn.nvim",
		ft = { "cs", "razor" },
		dependencies = {
			{
				"tris203/rzls.nvim",
				config = true,
			},
		},
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		opts = {
			-- your configuration comes here; leave empty for default settings
		},

		config = function()
			local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
			local cmd = {
				"roslyn",
				"--stdio",
				"--logLevel=Information",
				"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
				"--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
				"--razorDesignTimePath="
					.. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
				"--extension",
				vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
			}

			vim.lsp.config("roslyn", {
				cmd = cmd,
				handlers = require("rzls.roslyn_handlers"),
				settings = {
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,

						csharp_enable_inlay_hints_for_lambda_parameter_types = true,
						csharp_enable_inlay_hints_for_types = true,
						dotnet_enable_inlay_hints_for_indexer_parameters = true,
						dotnet_enable_inlay_hints_for_literal_parameters = true,
						dotnet_enable_inlay_hints_for_object_creation_parameters = true,
						dotnet_enable_inlay_hints_for_other_parameters = true,
						dotnet_enable_inlay_hints_for_parameters = true,
						dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
					},
					["csharp|code_lens"] = {
						dotnet_enable_references_code_lens = true,
					},
				},
			})
			vim.lsp.enable("roslyn")
		end,
		init = function()
			-- We add the Razor file types before the plugin loads.
			vim.filetype.add({
				extension = {
					razor = "razor",
					cshtml = "razor",
				},
			})
		end,
	},
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "echasnovski/mini.icons" },
		opts = {},
	},
})
