require'plugins'
require'keymap'
require'lsp-config'
require'ddc-config'
require'telescope-config'
vim.cmd[[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]]