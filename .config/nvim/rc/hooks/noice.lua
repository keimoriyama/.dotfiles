-- lua_source {{{
require("noice").setup({
	lsp = {
		signature = {
			enabled = false,
			auto_open = {
				enabled = false,
				-- throttle = 0, -- Debounce lsp signature help request by 50ms
			},
		},
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	views = {
		cmdline_popup = {
			position = {
				row = "10%",
				col = "50%",
			},
			size = {
				width = 60,
				height = "auto",
			},
		},
		popupmenu = {
			relative = "editor",
			position = {
				row = "10%",
				col = "50%",
			},
			size = {
				width = 60,
				height = 10,
			},
			border = {
				style = "rounded",
				padding = { 0, 1 },
			},
			win_options = {
				winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
			},
		},
		confirm = {
			position = {
				row = "10%",
				col = "50%",
			},
		},
	},
})
-- }}}
