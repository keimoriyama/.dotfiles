local M = {}
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
function M.setup()
	later(function()
		add({
			source = "vim-skk/skkeleton",
			depends = {
				"vim-denops/denops.vim",
				"delphinus/skkeleton_indicator.nvim",
				"keimoriyama/skkeleton-azik-kanatable",
				"skk-dev/dict",
			},
		})
		skk_setup()
	end)
end

function skk_setup()
	local path_package = vim.fn.stdpath("data") .. "/site/"
	local dictdir = path_package .. "pack/deps/opt/dict"
	vim.keymap.set({ "i", "c" }, "<C-j>", "<Plug>(skkeleton-enable)", { noremap = true })
	vim.keymap.set({ "i", "c" }, "<C-l>", "<Plug>(skkeleton-disable)", { noremap = true })

	local userDict = vim.fn.expand("$HOME") .. "/.local/skkeleton/SKK-JISYO.L"

	vim.fn["skkeleton#azik#add_table"]("us")

	vim.fn["skkeleton#config"]({
		kanaTable = "azik",
	})
	vim.fn["skkeleton#register_keymap"]("henkan", "X", "")

	vim.fn["skkeleton#config"]({
		globalDictionaries = {
			vim.fs.joinpath(dictdir, "SKK-JISYO.L"),
			vim.fs.joinpath(dictdir, "SKK-JISYO.edict"),
			vim.fs.joinpath(dictdir, "SKK-JISYO.edict2"),
			vim.fs.joinpath(dictdir, "SKK-JISYO.fullname"),
			vim.fs.joinpath(dictdir, "SKK-JISYO.propernoun"),
		},
		userDictionary = userDict,
		debug = false,
	})
	require("skkeleton_indicator").setup()
end

return M
