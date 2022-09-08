local opts = { noremap = true, silent = true }
-- Shorten function name
local function keymap(mode, key, command, opt)
	opt = (opt == nil and opts) or opt
	return vim.api.nvim_set_keymap(mode, key, command, opt)
end

vim.g.mapleader = " "

keymap("", "<Space>", "<Nop>")

keymap("i", "jj", "<Esc>")
keymap("i", "jk", "<Esc>")

keymap("n", "<C-n>", ":NvimTreeToggle<CR>")


keymap("n", "<leader>fr", ":Rg<CR>")

keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")
keymap("n", "<leader>wq", "<C-w>q")

keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

vim.cmd("let g:vimspector_base_dir=expand('$HOME/.config/vimspector-config')")

