local global = require("draft.config")
local typo_config = global.configuration.typography

local selected_line = require("draft.typography.line")

---@return boolean is_comment Is actual decorated line commend
local function is_comment()
	return selected_line.text:match("^[\t ].*")
end

-- a submodule to highlight comments
---@class HLComment
local M = {}

-- Decorate line as comment
---@return NextStep next_step Return true if is NOT a comment
function M.try_highlight()
	if is_comment() then
		vim.api.nvim_buf_add_highlight(
			selected_line.buf_id,
			global.namespace,
			typo_config.comment_hl,
			selected_line.row_id,
			0,
			#selected_line.text
		)
		return false
	end
	return true
end

return M
