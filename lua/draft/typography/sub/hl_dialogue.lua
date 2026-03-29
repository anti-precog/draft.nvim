local global = require("draft.config")
---@type Config
local config = require("draft.config").configuration
local typo_config = config.typography

local selected_line = require("draft.typography.line")

---@return boolean is_dialogue Is actual decorated line dialogue
local function is_start_with_dash()
	return selected_line.text:match("^" .. config.dash_symbol .. ".*")
end

-- A submodule to highlight dialogues
---@class HLDialogue
local M = {}

-- Decorate all dialogues in the line
---@return NextStep next_step Always return true
function M.highlight()
	if not is_start_with_dash() then
		return true
	end

	local line_len = #selected_line.text
	local pos = 1

	while pos <= line_len do
		local s, e = selected_line.text:find(config.dash_symbol, pos, true) -- first dash
		if not s then
			break
		end

		local next_s, next_e = selected_line.text:find(config.dash_symbol, e + 1, true) -- second dash
		if next_s then
			vim.api.nvim_buf_add_highlight(
				selected_line.buf_id,
				global.namespace,
				typo_config.dialogue_hl,
				selected_line.row_id,
				s - 1,
				next_e
			)
			pos = next_e + 1
		else
			-- if there is no second dash
			vim.api.nvim_buf_add_highlight(
				selected_line.buf_id,
				global.namespace,
				typo_config.dialogue_hl,
				selected_line.row_id,
				s - 1,
				line_len
			)
			break
		end
	end
	return true
end

return M
