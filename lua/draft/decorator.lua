-- PERF: Idea to optimalize: make cache for line during cursor position change
---@module "decorator"
local M = {}

local ns = vim.api.nvim_create_namespace("draft")

M.config = {
	indent = "   ",
	syntax = {
		commands = "NonText",
		quotes = "Statement",
		dialogues = "Statement",
	},
	filetypes = nil,
}
-- local draw_counter = {} -- debug

---@class Indenter
local Indenter = {}
Indenter.__index = Indenter

function Indenter:new(buf_nr)
	local self = setmetatable({}, Indenter)
	self.buf_nr = buf_nr
	return self
end

function Indenter:make(row_nr)
	vim.api.nvim_buf_set_extmark(self.buf_nr, ns, row_nr, 0, {
		-- virt_text = { { "->" .. draw_counter[row_nr] .. " ", "NonText" } }, -- debug
		virt_text = { { M.config.indent, "NonText" } },
		virt_text_pos = "inline",
		hl_mode = "combine",
	})
end

---@param win_id number
---@param row_nr number
---@param line string
function Indenter:center(win_id, row_nr, line)
	local win_half = vim.api.nvim_win_get_width(win_id) / 2
	local line_half = #line / 2
	local length = win_half - line_half
	if length <= 0 then
		return
	end
	local space = string.rep(" ", length)
	vim.api.nvim_buf_set_extmark(self.buf_nr, ns, row_nr, 0, {
		-- virt_text = { { space .. draw_counter[row_nr] .. " ", "NonText" } }, -- debug
		virt_text = { { space, "NonText" } },
		virt_text_pos = "inline",
		hl_mode = "combine",
	})
end

local Marker = {}
Marker.__index = Marker

---@param buf_nr number
function Marker:new(buf_nr)
	local self = setmetatable({}, Marker)
	self.buf_nr = buf_nr
	return self
end

---@param row_nr number
---@param line string
function Marker:comment(row_nr, line)
	vim.api.nvim_buf_add_highlight(self.buf_nr, ns, M.config.syntax.commands, row_nr, 0, #line)
end

---@param row_nr number
---@param line string
function Marker:quotes(row_nr, line)
	for s, e in line:gmatch('()"[^"]+"()') do
		vim.api.nvim_buf_add_highlight(self.buf_nr, ns, M.config.syntax.quotes, row_nr, s - 1, e - 1)
	end
end

---@param row_nr number
---@param line string
function Marker:dialogues(row_nr, line)
	local line_len = #line
	local pos = 1

	while pos <= #line do
		local s, e = line:find("—", pos, true) -- first dash
		if not s then
			break
		end

		local next_s, next_e = line:find("—", e + 1, true) -- second dash
		if next_s then
			vim.api.nvim_buf_add_highlight(self.buf_nr, ns, M.config.syntax.dialogues, row_nr, s - 1, next_e)
			pos = next_e + 1
		else
			-- if there is no second dash
			vim.api.nvim_buf_add_highlight(self.buf_nr, ns, M.config.syntax.dialogues, row_nr, s - 1, line_len)
			break
		end
	end
end

---@param line string
---@return boolean
local function is_comment(line)
	return line:match("^[\t ].*")
end

---@param line string
---@return boolean
local function is_asterix(line)
	return line:match("^%*+$")
end

---@param line string
---@return boolean
local function is_empty(line)
	return line == ""
end

---@param line string
---@return boolean
local function is_header(line)
	return line:match("^[A-Z].*[^.]$")
end

---@param buf_nr number
---@param row_nr number
---@return boolean
local get_line = function(buf_nr, row_nr)
	return vim.api.nvim_buf_get_lines(buf_nr, row_nr, row_nr + 1, false)[1]
end

---@return boolean
local is_insert_mode = function()
	return vim.api.nvim_get_mode().mode == "i"
end

---@return boolean
local function is_correct_ft(buf_nr)
	local ft = vim.bo[buf_nr].filetype
	for _, t in ipairs(M.config.filetypes) do
		if ft == t then
			return true -- typ jest w tabeli
		end
	end
	return false -- typ nie jest w tabeli
end

-- SETUP
function M.setup(opts)
	M.config.filetypes = opts.filetypes
	M.config.indent = opts.indent
	--	M.config.syntax = opts.syntax

	vim.api.nvim_set_decoration_provider(ns, {

		on_win = function(_, win_id, buf_nr, toprow, botrow)
			if not is_correct_ft(buf_nr) then
				return false
			end

			if is_insert_mode() then
				return true
			end

			vim.api.nvim_buf_clear_namespace(buf_nr, ns, toprow, botrow + 1)

			local lines = vim.api.nvim_buf_get_lines(buf_nr, toprow, botrow + 1, false)
			local marker = Marker:new(buf_nr)
			local indenter = Indenter:new(buf_nr)
			for i, line in ipairs(lines) do
				local row_nr = toprow + i - 1

				-- draw_counter[row_nr] = (draw_counter[row_nr] or 0) + 1 -- debug
				if is_comment(line) then
					marker:comment(row_nr, line)
				elseif is_asterix(line) or is_header(line) then
					indenter:center(win_id, row_nr, line)
				else
					indenter:make(row_nr)
					marker:dialogues(row_nr, line)
					marker:quotes(row_nr, line)
				end
			end
			return false
		end,

		on_line = function(_, win_id, buf_nr, row_nr)
			local cursor_line = vim.api.nvim_win_get_cursor(win_id)[1] - 1

			if cursor_line == row_nr then
				local marker = Marker:new(buf_nr)
				local indenter = Indenter:new(buf_nr)
				-- draw_counter[row_nr] = (draw_counter[row_nr] or 0) + 1 -- debug
				vim.api.nvim_buf_clear_namespace(buf_nr, -1, row_nr, row_nr + 1)
				local line = get_line(buf_nr, row_nr)

				if is_comment(line) then
					marker:comment(row_nr, line)
				elseif row_nr ~= 0 and is_empty(line) then
					local prev_line = get_line(buf_nr, row_nr - 1)
					if is_asterix(prev_line) or is_header(prev_line) then
						vim.api.nvim_buf_clear_namespace(buf_nr, -1, row_nr - 1, row_nr)
						indenter:center(win_id, row_nr - 1, prev_line)
					end
				else
					indenter:make(row_nr)
					marker:dialogues(row_nr, line)
					marker:quotes(row_nr, line)
				end
			end
		end,
	})
end

return M
