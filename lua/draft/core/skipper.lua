local utils = require("draft.utils")

-- Check if text content is section or group header & footer
---@param text string content of line to check
---@return boolean is_meta is line start with # or > or <
local function is_meta(text)
	return text:match("^[><].*")
end

-- A submodule for skip lines
---@class Skipper
local M = {}

local prev_cursor_line_nr = -1

-- Prevent a cursor to land on meta line if user move down
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
		--[[ FIX: skip in both direction is broken
	elseif cursor_line_nr < prev_cursor_line_nr then
		local text = vim.fn.getline(cursor_line_nr)
		while is_meta(text) do
			vim.cmd("normal! k")
			if cursor_line_nr == last_line_nr then
				break
			end
			cursor_line_nr = utils.get_cursor_line_nr()
			text = vim.fn.getline(cursor_line_nr)
		end
		--]]
	end

	prev_cursor_line_nr = cursor_line_nr
end

return M
