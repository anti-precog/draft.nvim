-- Main module
---@class Draft
local draft = {}

---@param opts table Options configured by user
function draft.setup(opts)
	local config = require("draft.config").setup(opts).configuration

	if config.core then
		-- load core module according to user configuration
		require("draft.core").setup()
	end
	if config.typography then
		-- load typography module according to user configuration
		require("draft.typography").setup()
	end
end

return draft
