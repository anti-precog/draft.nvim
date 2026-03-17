local config = require("draft.config").options
local ns = require("draft.config").namespace
local line = require("draft.decorator.line")

--local draw_counter = {} -- debug

---@return boolean
local function clear_line()
	vim.api.nvim_buf_clear_namespace(line.buf, ns, line.row, line.row + 1)
	return true
end

---@type table<number, fun()>
local steps = {}
---@type table<number, fun()>
local post_steps = {}

-- a module for decorate lines into paragraphs
---@class paragrapher
local M = {}

-- set current line to decorate
---@param win_id integer
---@param buf_nr integer
---@param row_nr integer
---@param text string
function M.set_line(win_id, buf_nr, row_nr, text)
	line.win = win_id
	line.buf = buf_nr
	line.row = row_nr
	line.text = text
end

-- run all steps
---@param clean boolean
function M.run(clean)
	local start = clean and 1 or 2

	for i = start, #steps do
		local is_next = steps[i]()
		if not is_next then
			return
		end
	end
end

-- run post steps
function M.post_run()
	for i = 1, #post_steps do
		local is_next = post_steps[i]()
		if not is_next then
			return
		end
	end
end

-- init module
function M.setup()
	table.insert(steps, clear_line)
	if config.syntax.comment then
		table.insert(steps, require("draft.decorator.hl_comment").try_make)
	end
	if config.center.asterix then
		table.insert(steps, require("draft.decorator.headliner").try_center_asterix)
		table.insert(post_steps, require("draft.decorator.headliner").try_recenter_asterix)
	end
	if config.center.header and config.syntax.header then
		table.insert(steps, require("draft.decorator.headliner").try_make_title)
		table.insert(post_steps, require("draft.decorator.headliner").try_remake_title)
	elseif config.center.header then
		table.insert(steps, require("draft.decorator.headliner").try_center_header)
		table.insert(post_steps, require("draft.decorator.headliner").try_recenter_header)
	elseif config.syntax.header then
		table.insert(steps, require("draft.decorator.headliner").try_hl_header)
		table.insert(post_steps, require("draft.decorator.headliner").try_rehl_header)
	end
	if config.indent > 0 then
		table.insert(steps, require("draft.decorator.indenter").make_indent)
	end
	if config.syntax.quote then
		table.insert(steps, require("draft.decorator.hl_quote").make)
	end
	if config.syntax.dialogue then
		table.insert(steps, require("draft.decorator.hl_dialogue").make)
	end
	return M
end

return M
