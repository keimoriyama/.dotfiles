local status, obsidian = pcall(require, 'obsidian')
if not status then return end

local files = vim.fn.expand("%:p")
local obsidian_dir = '~/Documents'

-- ここをもう少しうまく描きたいところではある
if string.match(files, "daily_notes") then
	print("daily ")
	obsidian_dir = 	'~/Documents/daily_notes/summary/'
end
if string.match(files, "BirdCLEF") then
	print("BirdCLEF")
	obsidian_dir = 	'~/Program/kaggle/BirdCLEF2023/notes'
end

obsidian.setup({
  dir = obsidian_dir,
  completion = {
    nvim_cmp = true,
  },
  daily_notes = { folder = 'daily' },
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
    return suffix
  end
})

vim.keymap.set(
  "n",
  "gf",
  function()
    if obsidian.util.cursor_on_markdown_link() then
      return "<cmd>ObsidianFollowLink<CR>"
    else
      return "gf"
    end
  end,
  { noremap = false, expr = true }
)
