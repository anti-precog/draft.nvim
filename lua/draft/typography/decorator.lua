---@alias NextStep boolean Continue or break next step

local global = require("draft.config")
local typo_config = require("draft.config").configuration.typography
local selected_line = require("draft.typography.line")

---@type table<number, fun()> All implemented decoration steps
local decoration_steps = {}

---@type table<number, fun()> Post decoratipn steps
local post_decoration_steps = {}

---@param func fun(): NextStep Next action to do in ordered decoration steps
local function add_step(func)
	table.insert(decoration_steps, func)
end

---@param func fun(): NextStep Next action to do in post decoration proces
local function add_post_CR_step(func)
	table.insert(post_decoration_steps, func)
end

-- Decorate lines into paragraphs
---@class Decorator
local M = {}

function M.clear_decoration()
	selected_line:clear(global.namespace)
end

---@param buf_id integer Buffer handle
---@param begin_row_id integer Begin row to start clearing
---@param end_row_id integer End row to stop clearing
function M.clear_decoration_for_range(buf_id, begin_row_id, end_row_id)
	vim.api.nvim_buf_clear_namespace(buf_id, global.namespace, begin_row_id, end_row_id + 1)
end

-- Set current line to decorate
---@param win_id integer Current decorated window id
---@param buf_id integer Current decorated buffer id
---@param row_id integer Current decorated row id
---@param text string Current decorated text
function M.target(win_id, buf_id, row_id, text)
	selected_line.win_id = win_id
	selected_line.buf_id = buf_id
	selected_line.row_id = row_id
	selected_line.text = text
end

-- Run all decoration steps in order
function M.run()
	for _, step in ipairs(decoration_steps) do
		if not step() then
			return
		end
	end
end

-- Run post decoration steps in order
function M.post_run()
	for id = 1, #post_decoration_steps do
		if not post_decoration_steps[id]() then
			return
		end
	end
end

-- Init decorator
---@return Decorator
function M.init()
	-- PERF: for best performance: the fastest and next the most common steps shoud be first
	-- reason: some of steps stops rest in the queue
	if typo_config.center_header then
		add_step(require("draft.typography.sub.headliner").try_center_header)
		add_post_CR_step(require("draft.typography.sub.headliner").try_recenter_header)
	end
	if typo_config.center_asterix then
		add_step(require("draft.typography.sub.headliner").try_center_asterix)
		add_post_CR_step(require("draft.typography.sub.headliner").try_recenter_asterix)
	end
	if global.has_parser and typo_config.group_frames then
		add_step(require("draft.typography.ts.frames").try_set_frame_line)
	end
	if typo_config.indent_size > 0 then
		add_step(require("draft.typography.sub.indenter").try_make_indent_by_regex)
	end
	return M
end

return M
