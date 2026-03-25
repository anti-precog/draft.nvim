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

return line
