---@class Utils
local M = {}

-- Check nvim INSERT mode status
---@return boolean is_insert_mode Status of current vim INSERT mode
function M.is_insert_mode()
	return vim.api.nvim_get_mode().mode == "i"
end

---@return integer line_nr Current postion of cursor
function M.get_cursor_line_nr()
	return vim.api.nvim_win_get_cursor(0)[1]
end

---@return integer row_id Current postion of cursor
function M.get_cursor_row_id()
	return M.get_cursor_line_nr() - 1
end

---@return integer line_nr Last current buffer line number
function M.get_last_line_nr()
	return vim.api.nvim_buf_line_count(0)
end

---@return integer row_id Last current buffer row_id
function M.get_last_row_id()
	return M.get_last_line_nr() - 1
end

return M
