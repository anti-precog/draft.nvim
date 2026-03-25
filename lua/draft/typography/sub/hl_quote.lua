local global = require("draft.config")
---@type TypographyConfig
local typo_config = global.configuration.typography

local selected_line = require("draft.typography.line")

-- A submodule to highlight quotes
---@class HlQuotes
local M = {}

local quote_open = "„"
local quote_close = "”"

-- Decorate all quotes in the line
---@return NextStep next_step Always return true
function M.highlight()
	for s, e in selected_line.text:gmatch("()" .. quote_open .. "[^" .. quote_open .. "]+" .. quote_close .. "()") do
		vim.api.nvim_buf_add_highlight(
			selected_line.buf_id,
			global.namespace,
			typo_config.quote_hl,
			selected_line.row_id,
			s - 1,
			e - 1
		)
	end
	return true
end

return M
