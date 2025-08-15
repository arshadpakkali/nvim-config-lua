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
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

vim.lsp.config("jsonls", {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})
vim.lsp.config("yamlls", {
	settings = {
		yaml = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

vim.diagnostic.config({
	virtual_text = true,
})
vim.lsp.config("roslyn", {
	capabilities = capabilities,
	on_attach = on_attach,
})
