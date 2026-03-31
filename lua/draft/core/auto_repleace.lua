---@type Config
local config = require("draft.config").configuration
local core_config = config.core

local QUOTE = {
	straight = '"',
	open = "„",
	close = "”",
}

---@param text string Text line with probable qution marks
---@return boolean quote_status Check if in the line quote is already open
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
	vim.keymap.set("i", core_config.repleace_dash, config.dash_symbol, { buffer = true })
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
