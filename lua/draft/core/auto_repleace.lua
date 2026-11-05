local config = require("draft.config").setup
---@type CoreConfig|boolean
local core_config = config.core

local QUOTE = {
	straight = '"',
	open = "„",
	close = "”",
}

local EM_DASH = "—"

---@param text string text line with probable quote marks
---@return boolean quote_status is already closed
local function is_quote_closed_in(text)
	local open_count = select(2, text:gsub(QUOTE.open, ""))
	local close_count = select(2, text:gsub(QUOTE.close, ""))

	return open_count == close_count
end

-- A submodule for auto replacement symbols
---@class AutoRepleaceSubmodule
local M = {}

-- Map key for repleacement of dash symbol
function M.dash_keymap()
	vim.keymap.set("i", core_config.repleace_dash, EM_DASH, { buffer = true })
end

-- Map key for repleacement of ellipsis symbol
function M.ellipsis_keymap()
	vim.keymap.set("i", core_config.repleace_ellipsis, "…", { buffer = true })
end

-- Map key for repleacement of smart quotes
function M.quotes_keymap()
	vim.keymap.set("i", QUOTE.straight, function()
		local text = vim.api.nvim_get_current_line()
		if is_quote_closed_in(text) then
			return QUOTE.open
		else
			return QUOTE.close
		end
	end, { expr = true, buffer = true })
end

return M
