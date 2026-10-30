---@class Utils
local M = {}

---@return userdata|nil TSNode node from selected line
---@param buf_id number
---@param row_id number
function M.get_node(buf_id, row_id)
	return vim.treesitter.get_node({
		bufnr = buf_id,
		pos = { row_id, 0 },
	})
end

---@param buf_id integer Buffer handle
---@return boolean status Is buffer filetype draft
function M.is_draft_type(buf_id)
	return "draft" == vim.bo[buf_id].filetype
end

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
-- HACK: duplicated in typography/init
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
