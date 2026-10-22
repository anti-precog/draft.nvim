local utils = require("draft.utils")

---@return string group_name If line in TS group, then return text from line started with @
_G.find_group_name = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local row = utils.get_cursor_row_id()

	local node = vim.treesitter.get_node({ bufnr = bufnr, pos = { row, 0 } })

	while node do
		if node:type() == "group" then
			-- Pobieramy tylko numer początkowego wiersza grupy (zwraca indeks od 0)
			local start_row = node:range()

			-- Pobieramy z bufora bezpośrednio tę jedną, konkretną linię
			local line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1]

			return " " .. (line or "") .. " "
		end
		node = node:parent()
	end

	return ""
end

-- A submodule for status info bar
---@class Status
local M = {}

function M.redraw()
	vim.opt_local.winbar = "%#StatusLine#%{v:lua.find_group_name()}%="
end

return M
