---@class Utils
local M = {}

-- Get treesitter node from vim row
-- TODO: Consider repleacing buf_id to 0
---@return userdata|nil TSNode node from selected line
---@param buf_id number
---@param row_id number
function M.get_node(buf_id, row_id)
	return vim.treesitter.get_node({
		bufnr = buf_id,
		pos = { row_id, 0 },
	})
end

-- TODO: Consider repleacing buf_id to 0
---@param buf_id integer buffer handle
---@return boolean status is buffer filetype draft
function M.is_draft_type(buf_id)
	return "draft" == vim.bo[buf_id].filetype
end

-- Check nvim INSERT mode status
---@return boolean is_insert_mode status of current vim INSERT mode
function M.is_insert_mode()
	return vim.api.nvim_get_mode().mode == "i"
end

-- TODO: Consider if static buf_id as 0 is save in all scenarios
---@return integer line_nr current postion of cursor in vim
function M.get_cursor_line_nr()
	return vim.api.nvim_win_get_cursor(0)[1]
end

---@return integer row_id current postion of cursor in vim
function M.get_cursor_row_id()
	return M.get_cursor_line_nr() - 1
end

-- TODO: Consider if static buf_id as 0 is save in all scenarios
---@return integer line_nr last current buffer line number in vim
function M.get_last_line_nr()
	return vim.api.nvim_buf_line_count(0)
end

---@return integer row_id last current buffer row_id in vim
function M.get_last_row_id()
	return M.get_last_line_nr() - 1
end

return M
