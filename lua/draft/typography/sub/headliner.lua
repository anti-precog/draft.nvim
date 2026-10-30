local global = require("draft.config")

local utils = require("draft.utils")
local selected_line = require("draft.typography.line")

---@return boolean is_asterix check if current line represent asterix
local function is_asterix()
	return selected_line.text:match("^%*+$")
end

---@return boolean is_section check if current line represent section
local function is_section()
	return selected_line.text:match("^#")
end

local function make_center()
	local win_half = vim.api.nvim_win_get_width(selected_line.win_id) / 2 - 1
	local line_half = #selected_line.text / 2
	local length = win_half - line_half
	if length <= 0 then
		return
	end
	local space = string.rep(" ", length)
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { space, "NonText" } },
		virt_text_pos = "inline",
		hl_mode = "combine",
	})
end

local function clear_line()
	selected_line:clear(global.namespace)
end

-- A submodule to decorate titles and asterixes
---@class Headliner
local M = {}

-- Center if section
---@return NextStep next_step Return true if is NOT section or in insert mode
function M.try_center_header()
	if utils.is_insert_mode() then
		return true
	end
	if is_section() then
		make_center()
		return false
	end
	return true
end

-- Center if section with line decoration reset
---@return NextStep next_step Return true if is NOT section
function M.try_recenter_header()
	if is_section() then
		clear_line()
		make_center()
		return false
	end
	return true
end

-- Center if asterix
---@return NextStep next_step Return true if is NOT asterix or in insert mode
function M.try_center_asterix()
	if utils.is_insert_mode() then
		return true
	end
	if is_asterix() then
		make_center()
		return false
	end
	return true
end

-- Center if asterix with line decoration reset
---@return NextStep next_step Return true if is NOT asterix
function M.try_recenter_asterix()
	if is_asterix() then
		clear_line()
		make_center()
		return false
	end
	return true
end

return M
