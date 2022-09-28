local fn = vim.fn

-- Automatically install packer on XDG_DATA_HOME/nvim
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- do PackerSync on FileChange
vim.cmd([[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]])

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use)
	use("wbthomason/packer.nvim")
	use("lewis6991/impatient.nvim")
	use("junegunn/fzf.vim")
	use("unblevable/quick-scope")
	use({
		"kyazdani42/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({})
		end,
	})
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("lualine").setup({})
		end,
	})
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	})
	use({
		"folke/which-key.nvim",
		config = function()
			require("whichkey-conf")
		end,
	})

	use({
		"ellisonleao/gruvbox.nvim",
		config = function()
			require("gruvbox").setup({ contrast = "hard" })
			vim.cmd("colorscheme gruvbox")
		end,
	})

	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				view = {
					width = 35,
					mappings = {
						list = {
							{ key = "l", action = "edit" },
							{ key = "h", action = "close_node" },
						},
					},
				},
				update_focused_file = {
					enable = true,
					update_root = false,
				},
			})
		end,
	})
	use({
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip_conf")
		end,
	})
	use({
		"neovim/nvim-lspconfig",
		requires = {
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"jose-elias-alvarez/null-ls.nvim",
			"ray-x/lsp_signature.nvim",
			"b0o/schemastore.nvim",
		},
		config = function()
			require("lsp")
			require("lsp_servers")
		end,
	})
	use({
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	})

	use({
		"onsails/lspkind.nvim",
		config = function()
			require("lspkind").init()
		end,
	})

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = function()
			local telescopeActions = require("telescope.actions")

			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<Esc>"] = telescopeActions.close,
							["<C-u>"] = false,
						},
					},
				},
			})
		end,
	})

	use("tpope/vim-surround")
	use("tpope/vim-commentary")
	use("tpope/vim-fugitive")
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "lua", "typescript", "javascript", "go" },
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	})

	use({
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	})

	use({
		"puremourning/vimspector",
	})

	use({ "norcalli/nvim-colorizer.lua" })
	use({ "mattn/emmet-vim" })
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
