local cmp = require("cmp")

local telescope = require("telescope.builtin")

require("neodev").setup({
	library = { plugins = { "nvim-dap-ui" }, types = true },
})
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(), -- trigger completion
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
		{ name = "vim-dadbod-completion" }, -- For luasnip users.
		{ name = "cmp-dbee" },
		{ name = "path" }, -- For luasnip users.
		{ name = "orgmode" },
		{ name = "calc" },
	}),
	formatting = {
		format = require("lspkind").cmp_format({
			mode = "symbol_text",
			menu = {
				buffer = "[Buff]",
				nvim_lsp = "[Nvim_lsp]",
				luasnip = "[Luasnip]",
				nvim_lua = "[Nvim_Lua]",
				["vim-dadbod-completion"] = "[dadbod]",
				["cmp-dbee"] = "[cmp-dbee]",
			},
		}),
	},
})

require("cmp").setup({
	enabled = function()
		return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
	end,
})

require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
	sources = {
		{ name = "dap" },
	},
})

require("lsp_signature").setup()

local on_attach = function(client, bufnr)
	vim.diagnostic.config({
		virtual_text = {
			source = true,
		},
		float = {
			source = true,
		},
	})
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
	vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set("n", "gr", function()
		telescope.lsp_references({ include_declaration = false })
	end, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
	vim.keymap.set("n", "<A-k>", vim.lsp.buf.signature_help, bufopts)

	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
	vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)

	vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set("n", "<space>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)

	vim.keymap.set("n", "<space>qf", vim.lsp.buf.code_action, bufopts)
	vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)

	vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, bufopts)

	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end, bufopts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
	end, bufopts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local lsp_server_settings = {
	jsonls = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
	yamlls = {
		yaml = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
}

local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = lsp_server_settings[server_name],
		})
	end,
	["html"] = function()
		require("lspconfig")["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			init_options = {
				configurationSection = { "html", "css", "javascript" },
				embeddedLanguages = {
					css = true,
					javascript = true,
				},
				provideFormatter = true,
			},
		})
	end,
	["angularls"] = function()
		local cmd = {
			"ngserver",
			"--tsProbeLocations",
			"/home/arshad/.local/lib/node_modules/lib/",
			"--ngProbeLocations",
			"/home/arshad/.local/lib/node_modules/lib",
			"--stdio",
		}
		require("lspconfig")["angularls"].setup({
			cmd = cmd,
			on_new_config = function(new_config, new_root_dir)
				new_config.cmd = cmd
			end,
			capabilities = capabilities,
			on_attach = on_attach,
		})
	end,
})

-- local null_ls = require("null-ls")
--
-- null_ls.setup({
-- 	sources = {
-- 		null_ls.builtins.formatting.stylua,
-- 		null_ls.builtins.formatting.shfmt,
-- 		null_ls.builtins.formatting.black,
-- 		-- null_ls.builtins.formatting.sqlfmt,
-- 		-- null_ls.builtins.formatting.sqlfluff.with({
-- 		--     extra_args = { "--dialect", "postgres" },
-- 		-- }),
-- 		null_ls.builtins.formatting.sql_formatter.with({ extra_args = { "-l", "postgresql" } }),
-- 		null_ls.builtins.diagnostics.shellcheck,
-- 		null_ls.builtins.code_actions.shellcheck,
-- 	},
-- })
