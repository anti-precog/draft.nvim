local config = require("draft.config").options
local ns = require("draft.config").namespace

local line = require("draft.decorator.line")

-- a submodule to highlight quotes
---@class hl_quotes
local M = {}

---@return boolean
function M.make()
	for s, e in line.text:gmatch('()"[^"]+"()') do
		vim.api.nvim_buf_add_highlight(line.buf, ns, config.syntax.quote, line.row, s - 1, e - 1)
	end
	return true
end

return M
