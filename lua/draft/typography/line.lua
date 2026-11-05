-- Info about current decorated line
---@class LineInfo
local line = {
	---@type integer? window id
	win_id = nil,
	---@type integer? buffer id
	buf_id = nil,
	---@type integer? row id
	row_id = nil,
	---@type string? value of line
	text = nil,
}

--- Clear the line from namespace -> potencial decorations
---@param namespace integer
function line:clear(namespace)
	vim.api.nvim_buf_clear_namespace(self.buf_id, namespace, self.row_id, self.row_id + 1)
end

return line
