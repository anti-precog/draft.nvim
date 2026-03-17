local function setup_vim()
	vim.opt_local.wrap = true
	vim.opt_local.linebreak = true
	vim.opt_local.breakindent = true
end

-- a submodule for repleacement nvim keys (j/k) to move on visual not real lines
---@class visual_move_keys
local M = {}

-- init feature
function M.setup()
	setup_vim()
	vim.keymap.set("n", "j", function()
		return vim.v.count == 0 and "gj" or "j"
	end, { expr = true, buffer = 0 })

	vim.keymap.set("n", "k", function()
		return vim.v.count == 0 and "gk" or "k"
	end, { expr = true, buffer = 0 })
end

return M
