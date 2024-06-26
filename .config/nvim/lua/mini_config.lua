-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })
local now, later = MiniDeps.now, MiniDeps.later

-- Safely execute immediately
now(function()
	vim.o.termguicolors = true
	vim.cmd("colorscheme randomhue")
	require("mini.notify").setup()
	vim.api.nvim_create_user_command("NotifyLog", function()
		-- local logs = vim.inspect(MiniNotify.get_all())
		local logs = MiniNotify.get_all()
		for i, log in ipairs(logs) do
			print(log.msg)
		end
	end, {})
	vim.notify = require("mini.notify").make_notify()
	require("mini.tabline").setup()
	require("mini.statusline").setup({
		set_vim_settings = false,
	})
	require("mini.surround").setup({
		mappings = {
			add = "ya", -- Add surrounding in Normal and Visual modes
			delete = "yd", -- Delete surrounding
			find = "yf", -- Find surrounding (to the right)
			find_left = "yF", -- Find surrounding (to the left)
			highlight = "yh", -- Highlight surrounding
			replace = "yr", -- Replace surrounding
			update_n_lines = "yn", -- Update `n_lines`
		},
	})
	require("mini.indentscope").setup({
		draw = {
			delay = 0,
		},
	})
	require("mini.pairs").setup()
	require("mini.cursorword").setup()
end)

local function git_setup()
	vim.keymap.set({ "n", "x" }, "<Leader>gs", "<CMD>Git status<cr>", { desc = "Show at cursor" })
	vim.keymap.set({ "n", "x" }, "<Leader>gc", "<CMD>Git commit<CR>", { desc = "Show at cursor" })
	vim.keymap.set({ "n", "x" }, "<Leader>ga", "<CMD>Git add .<CR>", { desc = "Show at cursor" })
end

local function bufremove_setup()
	local function delete_buf()
		local bufnr = vim.api.nvim_get_current_buf()
		MiniBufremove.delete(bufnr)
	end
	vim.keymap.set("n", "<leader>bd", function()
		delete_buf()
	end)
end
later(function()
	require("mini.ai").setup()
	require("mini.comment").setup()
	require("mini.files").setup({
		windows = { preview = true },
	})
	vim.keymap.set("n", "<leader>sf", "<cmd>lua MiniFiles.open()<cr>")
	require("mini.git").setup()
	git_setup()
	require("mini.diff").setup()
	require("mini.jump").setup()
	require("mini.trailspace").setup()
	require("mini.bufremove").setup()
	bufremove_setup()
	-- require("mini.map").setup()
end)

require("rc.plugins").setup()
