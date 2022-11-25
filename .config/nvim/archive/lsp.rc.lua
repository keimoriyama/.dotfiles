require("nvim-lsp-installer").setup {}
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', 'H', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.signature_help, bufopts)

	vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
	vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
	vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)
	vim.keymap.set('n', '[d', vim.lsp.diagnostic.goto_prev, opts)
	vim.keymap.set('n', ']d', vim.lsp.diagnostic.goto_next, opts)
	vim.keymap.set('n', '<Leader>q', vim.lsp.diagnostic.set_loclist, opts)
	vim.keymap.set('n', '<Leader>f', vim.lsp.buf.formatting, opts)
end

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150,
}

-- add lsp
local servers = { 'clangd', 'pylsp', 'gopls', 'sumneko_lua' }

for _, lsp in ipairs(servers) do
	require('lspconfig')[lsp].setup {
		on_attach = on_attach,
		lsp_flags = lsp_flags,
	}
end

require 'lspconfig'.pylsp.setup {
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					on_attach = on_attach,
					lsp_flags = lsp_flags
				},
				autopep8 = {
					enabled = false
				},
			}
		}
	}
}
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]