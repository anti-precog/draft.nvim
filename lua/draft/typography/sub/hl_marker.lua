local global = require("draft.config")
local utils = require("draft.utils")
local typo_config = global.setup.typography

local selected_line = require("draft.typography.line")

local function set_hl()
	vim.api.nvim_set_hl(0, "UWAGA", {
		fg = "#68F527",
	})
end

set_hl()

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_hl,
})

-- A submodule to highlight quotes
---@deprecated Use nvim_treesitter_integration
---@class HlMarkers
local M = {}

M.active = false

---@return boolean is_comment Is actual decorated line commend
local function ends_with_marker()
	return selected_line.text:match("@[a-zA-Z0-9_-]+:?[^%s]*$") ~= nil
end

-- Decorate all quotes in the line
---@return NextStep next_step Always return true
function M.try_highlight()
	if not ends_with_marker() then
		return true
	end

	vim.api.nvim_buf_add_highlight(
		selected_line.buf_id,
		global.namespace,
		"UWAGA",
		selected_line.row_id,
		0,
		#selected_line.text
	)
	return false
end

return M
