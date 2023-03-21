vim.cmd([[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldtext=substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend))
set fillchars=fold:\\
set foldnestmax=3
set foldminlines=1
set foldlevel=9
]])
vim.api.nvim_create_autocmd({ "BufEnter" }, { pattern = { "*" }, command = "normal zx" })
