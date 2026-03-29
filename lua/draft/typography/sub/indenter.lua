local global = require("draft.config")
local typo_config = global.configuration.typography
local selected_line = require("draft.typography.line")

---@type string Represents indent
local space = string.rep(" ", typo_config.indent_size)

-- A submodule to make indents
---@class Indenter
local M = {}

-- Add an indent at the beginning of the line
---@return NextStep next_step Always return true
function M.make_indent()
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { space, "NonText" } },
		virt_text_pos = "inline",
		hl_mode = "combine",
	})
	return true
end
return M
