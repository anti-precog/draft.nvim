local utils = require("draft.utils")

---@param text string Line to check
---@return boolean is_meta Is the text start with @ or #
local function is_meta(text)
	return text:match("^[@#].*")
end

-- A submodule for skip lines
---@class Skipper
local M = {}

local prev_cursor_line_nr = -1

function M.try_skip()
	local cursor_line_nr = utils.get_cursor_line_nr()
	local last_line_nr = utils.get_last_line_nr()

	if cursor_line_nr > prev_cursor_line_nr then
		local text = vim.fn.getline(cursor_line_nr)
		while is_meta(text) do
			vim.cmd("normal! j")
			if cursor_line_nr == last_line_nr then
				break
			end
			cursor_line_nr = utils.get_cursor_line_nr()
			text = vim.fn.getline(cursor_line_nr)
		end
	end
	prev_cursor_line_nr = cursor_line_nr
end

return M
