local global = require("draft.config")
local typo_config = global.configuration.typography

local utils = require("draft.utils")

---@param buf_id integer Buffer handle
---@param row_id integer Window row position
---@return string content Text from the line
local get_line_content = function(buf_id, row_id)
	return vim.api.nvim_buf_get_lines(buf_id, row_id, row_id + 1, false)[1]
end

---@type Decorator
local decorator

---@param buf_id integer Buffer handle
---@param begin_row_id integer Begin row
---@param end_row_id integer End row
local function gather_lines(buf_id, begin_row_id, end_row_id)
	return vim.api.nvim_buf_get_lines(buf_id, begin_row_id, end_row_id + 1, false)
end

---@param win_id integer Window handle
---@return integer row_id Number of line where cursor is
-- HACK: duplicated in utils
local function get_cursor_row_id(win_id)
	return vim.api.nvim_win_get_cursor(win_id)[1] - 1
end

---@param win_id integer Window handle
---@param row_id integer Number of line
---@return boolean is_cursor_on_line is cursor position is on the line
local function is_cursor_on_line(win_id, row_id)
	return get_cursor_row_id(win_id) == row_id
end

---@param top_row_id integer top visable real number of line
---@param line_nr integer relative (from top) number of visable line
---@return integer row_id converted visable to real line number
local function visable_to_real_row_id(top_row_id, line_nr)
	return top_row_id + line_nr - 1
end

---@param buf_id integer Buffer handle
local function setup_post_cr_decore_mapping(buf_id)
	vim.keymap.set({ "i", "s" }, "<CR>", function()
		local win_id = vim.api.nvim_get_current_win()
		local cursor_row_id = get_cursor_row_id(win_id)
		if cursor_row_id >= 0 then
			local content = get_line_content(buf_id, cursor_row_id)

			decorator.target(win_id, buf_id, cursor_row_id, content)
			decorator.post_run()
		end
		return vim.api.nvim_replace_termcodes("<CR>", true, false, true)
	end, { buffer = buf_id, expr = true, noremap = true, silent = true })
end

-- Setup for decoration_provider and post CR text formating
---@class TypographyModule Setup for decoration_provider and post CR text formating
local M = {}

-- Init module
function M.setup()
	decorator = require("draft.typography.decorator").init()

	vim.api.nvim_set_decoration_provider(global.namespace, {

		-- NOMRAL & VISUAL modes: (vim)
		on_win = function(_, win_id, buf_id, top_row_id, bottom_row_id)
			if not utils.is_draft_type(buf_id) then
				return false -- do not make any decorations
			elseif utils.is_insert_mode() then
				return true -- skip to on_line decoration
			end

			decorator.clear_decoration_for_range(buf_id, top_row_id, bottom_row_id)
			local visable_lines = gather_lines(buf_id, top_row_id, bottom_row_id)

			for line_nr, content in ipairs(visable_lines) do
				local row_id = visable_to_real_row_id(top_row_id, line_nr)
				decorator.target(win_id, buf_id, row_id, content)
				decorator.run()
			end
			return false -- do not make on_line decoration
		end,

		-- INSERT mode: (vim)
		on_line = function(_, win_id, buf_id, row_id)
			if is_cursor_on_line(win_id, row_id) then
				local content = get_line_content(buf_id, row_id)
				decorator.target(win_id, buf_id, row_id, content)
				decorator.clear_decoration()
				decorator.run()
			end
		end,
	})

	if global.has_parser then
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "draft",
			callback = function(args)
				vim.treesitter.start(args.buf)
			end,
			desc = "activate tree-sitter parser for draft",
		})

		-- HACK: Redraw again after set filetype to prevent decoraor lag on first file open
		vim.api.nvim_create_autocmd("BufWinEnter", {
			callback = function(args)
				if utils.is_draft_type(args.buf) then
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(args.buf) then
							vim.cmd("redraw!")
						end
					end)
				end
			end,
			desc = "refresh decoration for draft",
		})
	end

	if typo_config.center_asterix or typo_config.center_header then
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "draft",
			callback = function(args)
				setup_post_cr_decore_mapping(args.buf)
			end,
			desc = "post <CR> decorate",
		})
	end
end

return M
