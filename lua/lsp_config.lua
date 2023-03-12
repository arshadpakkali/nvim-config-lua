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
        ["<C-b>"] = cmp.mapping.scroll_docs( -4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- trigger completion
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
        { name = "path" }, -- For luasnip users.
        { name = "neorg" },
    }),
    formatting = {
        format = require 'lspkind'.cmp_format({
            mode = "symbol_text",
            menu = {
                buffer = "[Buff]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
            },
        }),
    },
})

require("lsp_signature").setup()

local on_attach = function(client, bufnr)
    vim.diagnostic.config({
        virtual_text = {
            source = "always",
        },
        float = {
            source = "always",
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
    vim.keymap.set("n", "<space>f", function()
        vim.lsp.buf.format({
            filter = function(client)
                return client.name ~= "tsserver"
            end,
        })
    end, bufopts)

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
        if server_name == "angularls" then
            local cmd = {
                "ngserver",
                "--tsProbeLocations",
                "/home/arshad/.local/lib/node_modules/lib/",
                "--ngProbeLocations",
                "/home/arshad/.local/lib/node_modules/lib",
                "--stdio",
            }
            require("lspconfig")[server_name].setup({
                cmd = cmd,
                on_new_config = function(new_config, new_root_dir)
                    new_config.cmd = cmd
                end,
                capabilities = capabilities,
                on_attach = on_attach,
            })
            return
        end
        if server_name == "html" then
            require("lspconfig")[server_name].setup({
                capabilities = capabilities,
                on_attach = on_attach,
                init_options = {
                    configurationSection = { "html", "css", "javascript" },
                    embeddedLanguages = {
                        css = true,
                        javascript = true,
                    },
                    provideFormatter = false,
                },
            })
            return
        end

        require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = lsp_server_settings[server_name],
        })
    end,
})

require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.formatting.prettier,
        require("null-ls").builtins.formatting.shfmt,
        require("null-ls").builtins.formatting.black,
        require("null-ls").builtins.diagnostics.shellcheck,
        require("null-ls").builtins.code_actions.shellcheck,
    },
})
