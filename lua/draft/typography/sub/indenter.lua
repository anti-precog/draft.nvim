local global = require("draft.config")
local typo_config = global.configuration.typography
local selected_line = require("draft.typography.line")

---@type string Represents indent
local space = string.rep(" ", typo_config.indent_size)

---@return boolean is_comment Is actual decorated line commend
local function is_comment()
	return selected_line.text:match("^[\t ].*")
end

-- A submodule to make indents
---@class Indenter
local M = {}

-- Add an indent at the beginning of the line
---@return NextStep next_step Always return true
function M.try_make_indent()
	if is_comment() then
		return false
	end
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { space, "NonText" } },
		virt_text_pos = "inline",
		hl_mode = "combine",
	})
	return true
end
return M
