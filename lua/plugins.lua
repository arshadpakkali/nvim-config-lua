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

	use "wbthomason/packer.nvim"
	use "lewis6991/impatient.nvim"
	use "junegunn/fzf.vim"
	use "unblevable/quick-scope"
	use "tpope/vim-surround"
	use "tpope/vim-commentary"
	use {
		'lewis6991/gitsigns.nvim',
		config = function()
			require 'gitsigns'.setup()
		end
	}
	use {
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup {} end
	}
	use {
		"folke/which-key.nvim",
		config = function()
			require "which-key".setup()
		end
	}
	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.0',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use {
		"ellisonleao/gruvbox.nvim",
		config = function()
			require("gruvbox").setup({ contrast = "hard" })
			vim.cmd("colorscheme gruvbox")
		end
	}

	use {
		"kyazdani42/nvim-tree.lua",
		requires = "kyazdani42/nvim-web-devicons",
		wants = "nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup()
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
	}

	use {
		'neovim/nvim-lspconfig',
		requires = { "hrsh7th/nvim-cmp", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-vsnip", 'hrsh7th/vim-vsnip',
			"b0o/schemastore.nvim"
		},
		config = function()
			require("lsp")
		end
	}
	use {
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate"
	}


	use { "williamboman/mason.nvim",
		config = function()
			require "mason".setup()
		end
	}


	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end

end)
