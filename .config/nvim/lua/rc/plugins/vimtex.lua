local M = {}
local add, later, now = MiniDeps.add, MiniDeps.later, MiniDeps.now
function M.setup()
	now(function()
		vim.cmd([[
		let g:vimtex_view_method = "skim"
		let g:vimtex_view_general_viewer = "skim"
		let g:vimtex_view_skim_activate = 1
		let g:vimtex_view_skim_synmc = 1
		let g:vimtex_compiler_method = "latexmk"
		let g:vimtex_view_compiler_latexmk_engines = [ "-", "-pdf" ]
		let g:latex_latexmk_options = "-pdf"
		let g:vimtex_syntax_enabled = 0
		let g:vimtex_compiler_latexmk = {
			  \ 'background': 1,
			  \ 'build_dir': '',
			  \ 'continuous': 1,
			  \ 'options': [
			  \    '-pdfdvi',
			  \    '-verbose',
			  \    '-file-line-error',
			  \    '-synctex=1',
			  \    '-interaction=nonstopmode',
			  \],
			  \}
	  ]])
		add({ source = "lervag/vimtex" })
	end)
end

return M
