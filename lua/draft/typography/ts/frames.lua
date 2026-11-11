local global = require("draft.config")
local utils = require("draft.utils")
local selected_line = require("draft.typography.line")

local TOP_L = "┌─ "
local TOP_R = "─┐"
local MID = "─"
local MID_L = "├─"
local BOT_L = "└─ "
local BOT_R = "─┘"
local CONTEXT_L = "[...]"

local function draw_line()
	local win_id = selected_line.win_id

	-- Pobieramy szczegółowe informacje o oknie (zawiera m.in. textoff - szerokość kolumn bocznych)
	local win_info = vim.fn.getwininfo(win_id)[1]
	if not win_info then
		return
	end

	-- Całkowita szerokość minus kolumny boczne (numery, signcolumn, foldcolumn)
	local win_width = win_info.width - win_info.textoff

	local line_width = vim.api.nvim_strwidth(selected_line.text)
	local length = win_width - line_width - 2

	if length <= 0 then
		return
	end

	local fill = string.rep(MID, length)
	local col = #selected_line.text

	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, col, {
		virt_text = {
			{ " ", "NonText" },
			{ fill, "@comment" },
		},
		virt_text_pos = "inline",
		hl_mode = "combine",
	})
end

local function draw_top_line()
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { TOP_L, "@comment" } },
		virt_text_pos = "inline",
	})
	--vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
	--	virt_text = { { TOP_R, "@comment" } },
	--	virt_text_pos = "right_align",
	--})
end

local function draw_bottom_line()
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { CONTEXT_L, "@comment" } },
		virt_text_pos = "inline",
	})
	--vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
	--	virt_text = { { CONTEXT_L, "@comment" } },
	--	virt_text_pos = "right_align",
	--})
end

---@return boolean is_context check if current line represent main_context
local function is_context()
	return selected_line.text:match("^+")
end

---@return boolean is_head_context check if current line represent head_context
local function is_summary()
	return selected_line.text:match("^-")
end

---@return boolean is_marker check if current line represent foot_context
local function is_foot_context()
	return selected_line.text:match("^#")
end

-- a submodule to decorate groups by frames
---@class Frames
local M = {}

-- Draw frames on line
---@return NextStep next_step Return true if is NOT a comment
-- PERF: This is slower function than regex so use it as one of the last step in decorator to avoid uncecceary slower tree-sitter comunication
function M.try_set_frame_line()
	if is_context() then
		if utils.is_insert_mode() then
			return false
		end
		draw_line()
		return false
	end
	return true
end

return M
