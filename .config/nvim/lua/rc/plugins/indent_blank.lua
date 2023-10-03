---@type LazySpec
local spec = {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require('ibl').setup({})
		end,
	},
}
return spec
