local status, mason = pcall(require, 'mason')
if not status then return end

mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗"
		}
	}
})

local opts = { noremap = true, silent = true }

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
	vim.keymap.set('n', '<Leader>h', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', '<Leader>k', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<Leader>d', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, bufopts)
	vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
	vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
	vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, bufopts)
	vim.keymap.set('n', '<Leader>f',
		"<cmd>lua vim.lsp.buf.format({async=true})<CR>", bufopts)
end

local lsp_flags = {
	-- This is the default in Nvim 0.7+
	debounce_text_changes = 150
}

-- add lsp
local servers = { 'pyright', 'sumneko_lua', 'bashls', 'clangd' }

local status, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not status then return end

mason_lspconfig.setup({ ensure_installed = servers })

local status, lspconfig = pcall(require, 'lspconfig')
if not status then return end

for _, lsp in ipairs(servers) do lspconfig[lsp].setup({ on_attach = on_attach }) end