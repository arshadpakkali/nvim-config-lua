local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

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
	})
end
