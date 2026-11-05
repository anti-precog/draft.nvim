local utils = require("draft.utils")

-- TODO: Consider if buf_id could be zero
-- If line is in treesitter group, then return text from group header (started with '>')
---@return string content from group header
---@diagnostic disable: undefined-field
_G.find_group_header = function()
	local buf_id = vim.api.nvim_get_current_buf()
	local row_id = utils.get_cursor_row_id()

	local node = utils.get_node(buf_id, row_id)

	while node do
		if node:type() == "group" then
			local start_row = node:range()

			local line = vim.api.nvim_buf_get_lines(buf_id, start_row, start_row + 1, false)[1]

			return " " .. (line or "") .. " "
		end
		node = node:parent()
	end

	return ""
end

-- A submodule for status info bar
---@class Status
local M = {}

-- WARN: Experimental feature
-- WARN: It require treesitter parser
-- Re/Draw status bar
function M.redraw()
	vim.opt_local.winbar = "%#StatusLine#%{v:lua.find_group_header()}%="
end

return M
