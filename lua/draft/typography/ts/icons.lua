local global = require("draft.config")
local selected_line = require("draft.typography.line")

---@return boolean is_group Is actual decorated line group head
local function is_group_head()
	return selected_line.text:match("^[#].*")
end

---@return boolean is_group Is above decorated line group head
local function is_group_head_above()
	if selected_line.row_id == 0 then
		return false
	end
	local row_above = selected_line.row_id - 1
	local text = vim.api.nvim_buf_get_lines(0, row_above, row_above + 1, false)[1]

	return text:match("^[#].*")
end

---@return boolean is_group Is above decorated line group head
local function is_end_group_head_above()
	if selected_line.row_id == 0 then
		return false
	end
	local row_above = selected_line.row_id - 1
	local text = vim.api.nvim_buf_get_lines(0, row_above, row_above + 1, false)[1]

	return text:match("^#$")
end

---@return boolean is_end_group Is actual decorated line end group
local function is_end_group()
	return selected_line.text:match("^#$")
end

---@return boolean is_summary
local function is_summary()
	return selected_line.text:match("^[@].*")
end

-- a submodule to highlight comments
---@deprecated Use treesitter_integration
---@class HLComment
local M = {}

-- Add icon to next row
---@return NextStep next_step Return true if is NOT a comment
function M.try_set_group_icon()
	local icons = ""
	if is_end_group() then
		icons = "—"
	elseif is_group_head() then
		icons = "#"
	end
	if icons ~= "" then
		vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
			sign_text = icons,
			sign_hl_group = "NonText",
		})
		return false
	end

	return true
end

-- Add icon to next row
---@return NextStep next_step Return true if is NOT a comment
function M.try_set_summary_icon()
	if selected_line.row_id == 0 then
		return true
	end
	local prev_row = selected_line.row_id - 1

	local icons = ""
	if is_summary() then
		icons = "@"
		if is_end_group_head_above() then
			icons = "—@"
		elseif is_group_head_above() then
			icons = "#@"
		end
	end
	if icons ~= "" then
		vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, prev_row, 0, {
			sign_text = icons,
			sign_hl_group = "NonText",
		})
		return false
	end

	return true
end

return M
