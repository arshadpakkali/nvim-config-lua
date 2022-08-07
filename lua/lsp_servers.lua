local on_attach, capabilities = require("lsp")

require("lspconfig")["tsserver"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
	single_file_support = true,
})
require("lspconfig")["sumneko_lua"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			format = {
				enable = false,
			},
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})
require("lspconfig")["jsonls"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
	single_file_support = true,
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})
require("lspconfig")["yamlls"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		yaml = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})
require("lspconfig")["dockerls"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
require("lspconfig")["pyright"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.formatting.prettier,
	},
})
