local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local c = ls.choice_node

ls.config.set_config({
	history = true,
})

vim.keymap.set({ "i", "s" }, "<c-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
	if ls.jumpable() then
		ls.jump(-1)
	end
end, { silent = true })

vim.keymap.set("i", "<C-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })

local jsLike = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

for _, lang in ipairs(jsLike) do
	ls.add_snippets(lang, {
		s(
			"clg",
			fmt(
				[[
    console.log({})
    ]],
				{ i(1, "item") }
			)
		),
		s(
			"?:",
			fmt(
				[[
            {}?{}:{}
    ]],
				{ i(1, "cond"), i(2, "true"), i(3, "false") }
			)
		),
		s(
			"ecls",
			fmta(
				[[
                export class <> {

                }
    ]],
				{ i(1, "name") }
			)
		),
		s(
			"eaf",
			fmta(
				[[
                export async function <>() {

                }
    ]],
				{ i(1, "name") }
			)
		),
		s(
			"pam",
			fmta(
				[[
                private async <>() {

                }
    ]],
				{ i(1, "name") }
			)
		),
		s("prv", fmta([[private <>:<>]], { i(1, "name"), i(2, "className") })),
		s("imp", fmta([[import <> from '<>']], { i(1, "n"), i(2, "l") })),
		s("impa", fmta([[import * as <> from '<>']], { i(1, "n"), i(2, "l") })),
		s("impp", fmta([[import {<>} from '<>']], { i(1, "n"), i(2, "l") })),
	})
end

ls.add_snippets("sql", {

	s("pub", fmt([[public.{}]], { i(1, "table_name") })),
})
