local status, obsidian = pcall(require, "obsidian")
if not status then
	return
end

obsidian.setup({
	dir = "~/Documents/Notes",
	completion = {
		nvim_cmp = true,
	},
	daily_notes = { folder = "daily" },
	note_id_func = function(title)
		-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
		local suffix = ""
		if title ~= nil then
			-- If title is given, transform it into valid file name.
			suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
		else
			-- If title is nil, just add 4 random uppercase letters to the suffix.
			for _ = 1, 4 do
				suffix = suffix .. string.char(math.random(65, 90))
			end
		end
		return tostring(os.time()) .. "-" .. suffix
	end,
	ensure_installed = { "markdown", "markdown_inline", ... },
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "markdown" },
	},
})

vim.keymap.set("n", "<Leader>gf", function()
	if obsidian.util.cursor_on_markdown_link() then
		return "<cmd>ObsidianFollowLink<CR>"
	else
		return "gf"
	end
end, { noremap = false, expr = true })

vim.keymap.set("n", "<Leader>ot", "<cmd>ObsidianToday<cr>", { noremap = false, expr = false })
