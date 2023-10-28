local cache = vim.fn.expand("~/.cache/dpp")

local function InitPlugin(plugin)
	local dir = cache .. '/repos/github.com/' .. plugin
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.system({
			"git",
			"clone",
			"https://github.com/" .. plugin .. ".git",
			dir,
		})
	end
	vim.opt.rtp:prepend(dir)
end

vim.opt.compatible = false

-- set dpp source path
local dpp_base = vim.fn.expand("~/.cache/dpp")
-- set dpp runtime path
local dpp_src = vim.fn.expand('~/.cache/dpp/repos/github.com/Shougo/dpp.vim')
local denops_src = vim.fn.expand('~/.cache/dpp/repos/github.com/vim-denops/denops.vim')

local plugins = {
	"Shougo/dpp.vim",
	'vim-denops/denops.vim',
	'Shougo/dpp-ext-toml',
	"Shougo/dpp-ext-lazy",
	'Shougo/dpp-ext-installer',
	'Shougo/dpp-protocol-git',
	"Shougo/dpp-ext-local",
}
for _, plugin in ipairs(plugins) do
	InitPlugin(plugin)
end
-- Set dpp runtime path (required)
vim.opt.rtp:prepend(dpp_src)

if vim.fn["dpp#min#load_state"](dpp_base) then
	vim.opt.rtp:prepend(denops_src)
	vim.api.nvim_create_augroup("ddp", {})
	vim.api.nvim_create_autocmd("User", {
		pattern = 'DenopsReady',
		callback = function()
			vim.fn["dpp#make_state"](dpp_base, "~/.config/nvim/denops/dpp_config.ts")
		end
	})
end

--vim.api.nvim_create_autocmd("User", {
	--pattern = "Dpp:makeStatePost",
	--callback = function()
		--vim.cmd([[
		--source ~/.cache/dpp/nvim/state.vim
		--]])
	--end
--})
vim.cmd("filetype indent plugin on")
if vim.fn.has("syntax") then
	vim.cmd("syntax on")
end

vim.api.nvim_create_user_command(
	"DppMakeState",
	function()
		vim.fn["dpp#make_state"](dpp_base, "~/.config/nvim/denops/dpp_config.ts")
	end,
	{}
)
vim.api.nvim_create_user_command(
"DppInstall",
function()
	vim.fn["dpp#async_ext_action"]('installer','install')
end,
{}
)
vim.api.nvim_create_user_command(
"DppUpdate",
function()
	vim.fn["dpp#async_ext_action"]('installer','update')
end,
{}
)
vim.api.nvim_create_user_command(
"DppSource",
function()
	vim.fn["dpp#source"]()
end,
{}
)
