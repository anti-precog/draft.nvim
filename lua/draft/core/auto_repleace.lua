local config = require("draft.config").options

-- a submodule for auto replacement symbols
---@class auto_repleace
local M = {}

-- init auto replacement of dash symbol
function M.set_dash_key()
	vim.keymap.set("i", config.auto_repleace_symbols.dash, config.dash, { buffer = true })
end

return M
