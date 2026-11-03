local global = require("draft.config")
local utils = require("draft.utils")
local selected_line = require("draft.typography.line")

local function draw_top_line()
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { "┌─ ", "NonText" } },
		virt_text_pos = "inline",
	})
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { "─┐", "NonText" } },
		virt_text_pos = "right_align",
	})
end

local function draw_middle_line()
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { "├─ ", "NonText" } }, -- co ma się pojawić i jaki styl
		virt_text_pos = "inline", -- "inline" wklei to bezpośrednio przed węzłem
	})
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { "─┤", "NonText" } }, -- co ma się pojawić i jaki styl
		virt_text_pos = "right_align", -- "inline" wklei to bezpośrednio przed węzłem
	})
end

local function draw_bottom_line()
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { "└─ ", "NonText" } }, -- co ma się pojawić i jaki styl
		virt_text_pos = "inline", -- "inline" wklei to bezpośrednio przed węzłem
	})
	vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
		virt_text = { { "─┘", "NonText" } }, -- co ma się pojawić i jaki styl
		virt_text_pos = "right_align", -- "inline" wklei to bezpośrednio przed węzłem
	})
end

---Sprawdza, czy węzeł znajduje się wewnątrz grupy (szuka w górę drzewa)
---@param node TSNode|nil Węzeł Treesitter do sprawdzenia
---@return boolean is_in_group true if node is in group
local function is_in_group(node)
	if not node then
		return false
	end

	-- Przechodzimy w górę po rodzicach węzła
	---@diagnostic disable: undefined-field
	local current = node:parent()
	while current do
		-- Zamień "group" na dokładną nazwę typu węzła grupy z Twojego parsera Treesitter
		-- (możesz ją sprawdzić za pomocą komendy :InspectTree w Neovimie)
		if current:type() == "group" then
			return true
		end

		current = current:parent()
	end

	return false
end

-- a submodule to highlight comments
---@deprecated Use treesitter_integration
---@class HLComment
local M = {}

-- Add icon to next row
---@return NextStep next_step Return true if is NOT a comment
function M.try_set_group_icon()
	--local icons = ""
	local node = utils.get_node(selected_line.buf_id, selected_line.row_id)
	if not is_in_group(node) then
		return true
	end
	if node == nil then
		return true
	end
	if node:type() == "header" then
		if selected_line.row_id == 0 then
			draw_top_line()
			return true
		end
		local node_above = utils.get_node(selected_line.buf_id, selected_line.row_id - 1)
		if node_above and is_in_group(node_above) then
			if node_above:type() == "footer" then
				draw_top_line()
				return true
			else
				draw_middle_line()
				return true
			end
		else
			draw_top_line()
			return true
		end
	elseif node:type() == "footer" then
		draw_bottom_line()
		return true
	end
	--[[if icons ~= "" then
		vim.api.nvim_buf_set_extmark(selected_line.buf_id, global.namespace, selected_line.row_id, 0, {
			sign_text = icons,
			sign_hl_group = "NonText",
		})
		return false
	end]]

	return true
	--return true
end

return M
