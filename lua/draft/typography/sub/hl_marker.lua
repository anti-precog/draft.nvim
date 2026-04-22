local global = require("draft.config")
local typo_config = global.configuration.typography

local selected_line = require("draft.typography.line")

-- A submodule to highlight quotes
---@deprecated Use nvim_treesitter_integration
---@class HlMarkers
local M = {}

local marker_open = "%("
local marker_close = "%)"

-- Decorate all quotes in the line
---@return NextStep next_step Always return true
function M.highlight()
	for s, e in selected_line.text:gmatch("()" .. marker_open .. "[^" .. marker_open .. "]+" .. marker_close .. "()") do
		vim.api.nvim_buf_add_highlight(
			selected_line.buf_id,
			global.namespace,
			"Statement",
			selected_line.row_id,
			s - 1,
			e - 1
		)
	end

	return true
end

return M
