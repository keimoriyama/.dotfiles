local capabilities = require("ddc_nvim_lsp").make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
require("lspconfig").denols.setup({
	capabilities = capabilities,
})

if string.find(vim.fn.expand("%:p:h"), "Atcoder") then
	sources = { "nvim-lsp", "file", "vsnip", "mocword", "buffer", "around" }
else
	sources = { "nvim-lsp", "file", "vsnip", "mocword", "nvim-lua", "buffer", "around", "copilot" }
end

-- Use around source.
vim.fn["ddc#custom#patch_global"]({
	ui = "pum",
	sources = sources,
	autoCompleteEvents = {
		"InsertEnter",
		"TextChangedI",
		"TextChangedP",
		"CmdlineEnter",
		"CmdlineChanged",
		"TextChangedT",
	},
	cmdlineSources = {
		[":"] = { "cmdline", "cmdline-history", "around" },
	},
	sourceOptions = {
		["_"] = {
			matchers = { "matcher_head", "matcher_fuzzy" },
			sorters = { "sorter_rank" },
			converters = { "converter_fuzzy", "converter_remove_overlap", "converter_fuzzy" },
			minAutoCompleteLength = 1,
		},
		around = { mark = "a" },
		file = { mark = "f", isVolatile = true, forceCompletionPattern = [['\S/\S*']] },
		cmdline = { mark = "c" },
		buffer = { mark = "b" },
		["nvim-lsp"] = {
			mark = "lsp",
			forceCompletionPattern = [['\.\w*|:\w*|->\w*']],
			keywordPattern = "\\k*",
			dup = "keep",
		},
		["nvim-lua"] = { mark = "lua", forceCompletionPattern = "." },
		mocword = {
			mark = "moc",
			isVolatile = true,
		},
		vsnip = { mark = "vsnip" },
	},
	sourceParams = {
		around = { maxSize = 100 },
		buffer = { requireSameFiletype = false, forceCollect = true },
		["nvim-lsp"] = {
			enableResolveItem = true,
			enableAdditionalTextEdit = true,
			confirmBehavior = "insert",
			snippetEngine = vim.fn["denops#callback#register"](function(body)
				return vim.fn["vsnip#anonymous"](body)
			end),
		},
	},
})

-- path completion
vim.fn["ddc#custom#patch_filetype"]({ "ps1", "dosbatch", "autohotkey", "registry" }, {
	sourceOptions = {
		file = {
			forceCompletionPattern = [['\S\\\S*']],
		},
	},
	sourceParams = {
		file = {
			mode = [[win32]],
		},
	},
})

vim.g.signature_help_config = {
	contentsStyle = "currentLabel",
	viewStyle = "floating",
}
-- Use ddc.
vim.fn["ddc#enable"]()

-- Use signature help
vim.fn["signature_help#enable"]()

-- use pop up preview
vim.fn["popup_preview#enable"]()
