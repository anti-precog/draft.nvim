local global = require("draft.config")
local utils = require("draft.utils")
local typo_config = global.configuration.typography
local ts_config = global.configuration.treesitter_integration
local selected_line = require("draft.typography.line")

---@type string Represents indent
local space = string.rep(" ", typo_config.indent_size)

---@return boolean is_correct_node Is actual decorated line proper to indent
local function is_correct_node()
	local node = utils.get_node(selected_line.buf_id, selected_line.row_id)
	if node then
		return node:type() == "narrative" or node:type() == "speech"
	end
	return false
end

-- A submodule to make indents
---@class Indenter
local M = {}

-- Add an indent at the beginning of the line
---@return NextStep next_step Always return true
function M.try_make_indent()
	if not is_correct_node() then
		return true
	end

	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { space, "NonText" } },
		virt_text_pos = "inline",
		hl_mode = "combine",
	})
	return true
end
return M
