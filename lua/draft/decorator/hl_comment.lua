local config = require("draft.config").options
local ns = require("draft.config").namespace

local line = require("draft.decorator.line")

---@return boolean
local function is_comment()
	return line.text:match("^[\t ].*")
end

-- a submodule to highlight comments
---@class hl_comment
local M = {}

---@return boolean
function M.try_make()
	if is_comment() then
		vim.api.nvim_buf_add_highlight(line.buf, ns, config.syntax.comment, line.row, 0, #line.text)
		return false
	end
	return true
end

return M
