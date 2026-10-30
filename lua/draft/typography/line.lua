-- Info about current decorated line
---@class LineInfo
local line = {
	---@type integer? Window id
	win_id = nil,
	---@type integer? Buffer id
	buf_id = nil,
	---@type integer? Row id
	row_id = nil,
	---@type string? Value of line
	text = nil,
}

---@param namespace integer Clear the line from namespace -> potencial decorations
function line:clear(namespace)
	vim.api.nvim_buf_clear_namespace(self.buf_id, namespace, self.row_id, self.row_id + 1)
end

return line
