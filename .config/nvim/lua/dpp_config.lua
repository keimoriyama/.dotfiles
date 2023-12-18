local dpp_base = vim.fn.expand("~/.cache/dpp")
local function InitPlugin(plugin)
	local dir = dpp_base .. '/repos/github.com/' .. plugin
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.system({
			"git",
			"clone",
			"https://github.com/" .. plugin .. ".git",
			dir,
		})
	end
	vim.opt.rtp:append(dir)
end

vim.opt.compatible = false

-- set dpp runtime path
local dpp_src = dpp_base .. '/repos/github.com/Shougo/dpp.vim'
local denops_src = dpp_base .. '/.cache/dpp/repos/github.com/vim-denops/denops.vim'

InitPlugin('vim-denops/denops.vim')
InitPlugin("Shougo/dpp.vim")

vim.opt.rtp:append(dpp_src)
vim.opt.rtp:append(denops_src)

local dpp = require("dpp")
local config_file = vim.fn.expand("~/.config/nvim/rc/dpp_config.ts")

if dpp.load_state(dpp_base) then
	local plugins = {
		'Shougo/dpp-ext-toml',
		"Shougo/dpp-ext-lazy",
		'Shougo/dpp-ext-installer',
		'Shougo/dpp-protocol-git',
		"Shougo/dpp-ext-local",
	}
	for _, plugin in ipairs(plugins) do
		InitPlugin(plugin)
	end
	vim.api.nvim_create_autocmd("User", {
		pattern = 'DenopsReady',
		callback = function()
			vim.notify("dpp load_state() is failed")
			dpp.make_state(dpp_base, config_file)
		end
	})
else
	vim.api.nvim_create_autocmd(
		"BufWritePost", {
			pattern = { "*.lua", "*.vim", "*.toml", "*.ts", "vimrc", ".vimrc" },
			callback = function()
				vim.fn["dpp#check_files"]()
			end
		}
	)
end

vim.api.nvim_create_autocmd("User", {
	pattern = "Dpp:makeStatePost",
	callback = function()
		vim.notify("dpp make_state() is done")
	end,
})

vim.cmd("filetype indent plugin on")
if vim.fn.has("syntax") then
	vim.cmd("syntax on")
end

vim.g.dps_obsidian_base_dir = "~/Documents/Notes"
vim.g.dps_obsidian_daily_note_dir = "daily"
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>nn", "<cmd>DpsObsidianToday<cr>", opts)
vim.keymap.set("n", "gf", "<cmd>DpsObsidianFollowLink<CR>", opts)

vim.api.nvim_create_user_command(
	"DppMakeState",
	function()
		dpp.make_state(dpp_base, config_file)
	end,
	{}
)

vim.api.nvim_create_user_command(
	"DppLoad",
	function()
		dpp.load_state(dpp_base)
	end,
	{}
)

vim.api.nvim_create_user_command(
	"DppInstall",
	function()
		dpp.async_ext_action('installer', 'install')
	end,
	{}
)
vim.api.nvim_create_user_command(
	"DppUpdate",
	function()
		dpp.async_ext_action('installer', 'update')
	end,
	{}
)
vim.api.nvim_create_user_command(
	"DppSource",
	function()
		dpp.source()
	end,
	{}
)
vim.api.nvim_create_user_command(
	"DppClear",
	function()
		dpp.clear_state()
	end,
	{}
)
vim.api.nvim_create_user_command(
	"DppGet",
	function()
		dpp.get()
	end,
	{}
)
