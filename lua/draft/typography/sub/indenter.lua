local global = require("draft.config")
local utils = require("draft.utils")
local typo_config = global.configuration.typography
local selected_line = require("draft.typography.line")

---@type string Represents indent
local space = string.rep(" ", typo_config.indent_size)

---@return boolean is_comment Is actual decorated line commend
local function is_not_paragraph()
	return selected_line.text:match("^[\t ><#].*")
end

---@return boolean is_correct_node Is actual decorated line proper to indent
-- PERF: there is huge performance decline vs. is_not_paragraph() method
local function is_correct_node()
	local node = utils.get_node(selected_line.buf_id, selected_line.row_id)
	if node then
		return node:type() == "narrative" or node:type() == "speech"
	end
	return false
end

local function make_indent()
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { space, "NonText" } },
		virt_text_pos = "inline",
		hl_mode = "combine",
	})
end

-- A submodule to make indents
---@class Indenter
local M = {}

-- Add an indent at the beginning of the line by tree-sitter node
---@return NextStep next_step Always return true
-- PERF: better use regex cause better performance
function M.try_make_indent()
	if not is_correct_node() then
		return true
	end
	make_indent()
	return true
end

-- Add an indent at the beginning of the line by regex
---@return NextStep next_step Always return true
function M.try_make_indent_by_regex()
	if is_not_paragraph() then
		return true
	end
	make_indent()
	return true
end

return M
