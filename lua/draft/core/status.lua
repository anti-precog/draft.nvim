local utils = require("draft.utils")

-- TODO: Consider if buf_id could be zero
---@return string content from head_context (line started by '>')
_G.find_head_context = function()
	local buf_id = vim.api.nvim_get_current_buf()
	local row_id = utils.get_cursor_row_id()

	for r = row_id, 0, -1 do
		local line = utils.get_line_content(buf_id, r)
		if line then
			if line:match("^>>") or line:match("^<") then
				return ""
			elseif line:match("^>") then
				return " " .. line .. " "
			end
		end
	end

	return ""
end

-- A submodule for status info bar
---@class Status
local M = {}

-- WARN: Experimental feature
-- Re/Draw status bar
function M.redraw()
	vim.opt_local.winbar = "%#StatusLine#%{v:lua.find_head_context()}%="
end

return M
