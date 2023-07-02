local capabilities = require("ddc_nvim_lsp").make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
require("lspconfig").denols.setup({
	capabilities = capabilities,
})
require("ddc_nvim_lsp_setup").setup()

-- -- -- Use around source.
vim.fn["ddc#custom#patch_global"]({
	ui = "pum",
	sources = { "nvim-lsp", "file", "vsnip", "buffer", "around", "copilot" },
	autoCompleteEvents = {
		"InsertEnter",
		"TextChangedI",
		"TextChangedP",
		"CmdlineChanged",
	},
	cmdlineSources = {
		[":"] = { "cmdline", "cmdline-history", "around" },
	},
	sourceOptions = {
		around = { mark = "a" },
		file = { mark = "f", isVolatile = true, forceCompletionPattern = [['\S/\S*']] },
		cmdline = { mark = "c" },
		buffer = { mark = "b" },
		["_"] = {
			matchers = { "matcher_head", "matcher_fuzzy", "matcher_length" },
			sorters = { "sorter_fuzzy", "sorter_rank" },
			converters = { "converter_fuzzy", "converter_remove_overlap" },
			minAutoCompleteLength = 1,
		},
		["nvim-lsp"] = { mark = "lsp", forceCompletionPattern = [['\.\w*|:\w*|->\w*']] },
		vsnip = { mark = "vsnip" },
	},
	sourceParams = {
		around = { maxSize = 100 },
		buffer = { requireSameFiletype = false, forceCollect = true },
		copilot = { minAutoCompleteLength = 1 },
		["nvim-lsp"] = {
			enableResolveItem = true,
			enableAdditionalTextEdit = true,
			confirmBehavior = "insert",
		},
	},
})

-- コマンドライン補完の設定
vim.cmd([[
	nnoremap :       <Cmd>call CommandlinePre()<CR>:
	function! CommandlinePre() abort
		cnoremap <Tab>   <Cmd>call pum#map#insert_relative(+1)<CR>
		cnoremap <S-Tab> <Cmd>call pum#map#insert_relative(-1)<CR>
		cnoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
		cnoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
		cnoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
		cnoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
		autocmd User DDCCmdlineLeave ++once call CommandlinePost()
		" Enable command line completion for the buffer
		call ddc#enable_cmdline_completion()
	endfunction
	function! CommandlinePost() abort
		silent! cunmap <Tab>
		silent! cunmap <S-Tab>
		silent! cunmap <C-n>
		silent! cunmap <C-p>
		silent! cunmap <C-y>
		silent! cunmap <C-e>
	endfunction
]])

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
