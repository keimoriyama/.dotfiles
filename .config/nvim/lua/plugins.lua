local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
local status, lazy = pcall(require, "lazy")
if not status then
	print("lazy is not installed")
	return
end

-- LuaFormatter off
if vim.g.vscode then
	return nil
end
lazy.setup({
	-- color scheme
	"folke/tokyonight.nvim",
	-- status line
	"nvim-lualine/lualine.nvim",
	-- indent
	"lukas-reineke/indent-blankline.nvim", --
	-- auto pair and tag close
	"windwp/nvim-autopairs",
	"windwp/nvim-ts-autotag", --
	-- surround
	"kylechui/nvim-surround", --
	-- git
	"lewis6991/gitsigns.nvim",
	"dinhhuy258/git.nvim",
	"akinsho/git-conflict.nvim",
	"airblade/vim-gitgutter",
	"TimUntersberger/neogit",
	-- auto comment out
	"numToStr/Comment.nvim",
	"luochen1990/rainbow", --
	-- dot repeat
	"tpope/vim-repeat", --
	-- linter, formatter
	"jose-elias-alvarez/null-ls.nvim", --
	-- tility
	"nvim-lua/plenary.nvim",
	"nvim-lua/popup.nvim", -- fuzzy finder
	"nvim-telescope/telescope.nvim",
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim",
		},
	},
	-- File icons
	"kyazdani42/nvim-web-devicons",
	-- treesitter
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "yioneko/nvim-yati", dependencies = "nvim-treesitter/nvim-treesitter" },
	--	-- bufferline
	"akinsho/nvim-bufferline.lua", --
	-- show color
	"norcalli/nvim-colorizer.lua", --
	-- csv
	"Decodetalkers/csv-tools.lua",
	-- keep lastest cursor position
	"ethanholz/nvim-lastplace",
	-- mkdir
	"jghauser/mkdir.nvim",
	"tversteeg/registers.nvim",
	-- - code action list
	"aznhe21/actions-preview.nvim",
	-- sp
	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"nvimdev/lspsaga.nvim",
	-- vscode-like pictograms
	"onsails/lspkind-nvim",
	{
		"L3MON4D3/LuaSnip",
		version = "1.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	},
	-- cmp
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"yutkat/cmp-mocword",
	"hrsh7th/cmp-cmdline",
	"ray-x/cmp-treesitter",
	"hrsh7th/cmp-omni",
	"saadparwaiz1/cmp_luasnip",
	-- template
	"mattn/vim-sonictemplate",
	-- markdown
	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	"mattn/vim-maketable",
	"BurntSushi/ripgrep",
	-- copilot
	{ "zbirenbaum/copilot.lua", build = ":Copilot auth" },
	{ "zbirenbaum/copilot-cmp", dependencies = "copilot.lua" },
	-- { "github/copilot.vim", build = ":Copilot auth" },
	-- terminal setting
	"uga-rosa/ugaterm.nvim",
	-- tex plugin
	{ "lervag/vimtex", ft = { "tex", "bib" } },

	-- ddc
	-- "vim-denops/denops.vim",
	-- "matsui54/denops-signature_help",
	-- "matsui54/denops-popup-preview.vim",
	-- "Shougo/pum.vim",
	-- {
	-- 	"Shougo/ddc.vim",
	-- 	dependencies = {
	-- 		"Shougo/ddc-nvim-lsp",
	-- 		"Shougo/ddc-around",
	-- 		"LumaKernel/ddc-file",
	-- 		"matsui54/ddc-buffer",
	-- 		"Shougo/ddc-source-cmdline",
	-- 		"Shougo/ddc-source-cmdline-history",
	-- 		"Shougo/ddc-source-nvim-lsp",
	-- 		"Shougo/ddc-source-nextword",
	-- 		"Shougo/ddc-source-copilot",
	-- 		"LumaKernel/ddc-source-file",
	-- 		"Shougo/ddc-sorter_rank",
	-- 		"Shougo/ddc-ui-pum",
	-- 		"Shougo/ddc-converter_remove_overlap",
	-- 		"tani/ddc-fuzzy",
	-- 		"Shougo/ddc-matcher_head",
	-- 		"Shougo/ddc-matcher_length",
	-- 		"tani/ddc-path",
	-- 		"uga-rosa/ddc-nvim-lsp-setup",
	-- 	},
	-- },
	--ddu
	-- {
	-- 	"Shougo/ddu.vim",
	-- 	dependencies = {
	-- 		"Shougo/ddu-kind-file",
	-- 		"Shougo/ddu-ui-filer",
	-- 		"Shougo/ddu-ui-ff",
	-- 		"uga-rosa/ddu-source-lsp",
	-- 		"Shougo/ddu-source-file",
	-- 		"matsui54/ddu-source-help",
	-- 		"Shougo/ddu-source-file_rec",
	-- 		"Shougo/ddu-source-action",
	-- 		"Shougo/ddu-column-filename",
	-- 		"Shougo/ddu-commands.vim",
	-- 		"uga-rosa/ddu-filter-converter_devicon",
	-- 		"Shougo/ddu-filter-matcher_substring",
	-- 		"Shougo/ddu-filter-sorter_alpha",
	-- 	},
	-- },
})
vim.cmd([[colorscheme tokyonight]])
