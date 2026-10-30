local global = require("draft.config")
local utils = require("draft.utils")
local selected_line = require("draft.typography.line")

local TOP_L = "┌─ "
local TOP_R = "─┐"
local MID_L = "├─ "
local MID_R = "─┤"
local BOT_L = "└─ "
local BOT_R = "─┘"

local function draw_top_line()
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { TOP_L, "NonText" } },
		virt_text_pos = "inline",
	})
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { TOP_R, "NonText" } },
		virt_text_pos = "right_align",
	})
end

local function draw_middle_line()
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { MID_L, "NonText" } },
		virt_text_pos = "inline",
	})
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { MID_R, "NonText" } },
		virt_text_pos = "right_align",
	})
end

local function draw_bottom_line()
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { BOT_L, "NonText" } },
		virt_text_pos = "inline",
	})
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { BOT_R, "NonText" } },
		virt_text_pos = "right_align",
	})
end

---@return boolean is_header check if current line represent group header
local function is_header()
	return selected_line.text:match("^>")
end

---@return boolean is_footer check if current line represent group footer
local function is_footer()
	return selected_line.text:match("^<")
end

---@return userdata|nil TSNode node from one line below
local function get_node_below()
	if selected_line.row_id == utils.get_last_row_id() then
		return nil
	end
	return utils.get_node(selected_line.buf_id, selected_line.row_id + 1)
end

---@return userdata|nil TSNode node from one line above
local function get_node_above()
	if selected_line.row_id == 0 then
		return nil
	end
	return utils.get_node(selected_line.buf_id, selected_line.row_id - 1)
end

---@param node userdata|nil TSNode to check if in node group
---@return boolean in_group
local function is_in_group(node)
	if not node then
		return false
	end
	local parent = node:parent()
	while parent do
		if parent:type() == "group" then
			return true
		end
		parent = parent:parent()
	end
	return false
end

-- a submodule to decorate groups by frames
---@class Frames
local M = {}

-- Draw frames on line
---@return NextStep next_step Return true if is NOT a comment
-- PERF: This is slower function than regex so use it as one of the last step in decorator to avoid uncecceary slower tree-sitter comunication
function M.try_set_frame_line()
	if is_footer() then
		if is_in_group(get_node_below()) then
			draw_middle_line()
		else
			draw_bottom_line()
		end
	elseif is_header() then
		if is_in_group(get_node_above()) then
			draw_middle_line()
		else
			draw_top_line()
		end
		return false
	end
	return true
end

return M
