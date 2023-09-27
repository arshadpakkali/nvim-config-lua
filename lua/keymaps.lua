local opts = { noremap = true, silent = true }
local function keymap(mode, key, command, opt)
	opt = (opt == nil and opts) or opt
	return vim.api.nvim_set_keymap(mode, key, command, opt)
end

vim.g.mapleader = " "
vim.cmd[[let maplocalleader=","]]

keymap("", "<Space>", "<Nop>")

keymap("i", "jj", "<Esc>")
keymap("i", "jk", "<Esc>")

keymap("n", "<C-n>", ":NvimTreeToggle<CR>")

keymap("n", "<leader>fr", ":Rg<CR>")

keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize -2<CR>", opts)



keymap("n", "]q", ":cnext<CR>", opts)
keymap("n", "[q", ":cprev<CR>", opts)
