local opt = vim.opt

opt.timeoutlen = 300
opt.nu = true
opt.rnu = true
opt.smartindent = true
opt.incsearch = true
opt.smartcase = true
opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.clipboard = "unnamedplus"
opt.signcolumn = "yes"
opt.termguicolors = true

opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4

opt.conceallevel = 0
opt.splitright = true
opt.updatetime = 300
opt.writebackup = false
opt.wrap = false -- display lines as one long line

opt.scrolloff = 5
opt.sidescrolloff = 5
opt.colorcolumn = "80"

vim.cmd([[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldtext=substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend))
set fillchars=fold:\\
set foldnestmax=3
set foldminlines=1
set foldlevel=9
]])
