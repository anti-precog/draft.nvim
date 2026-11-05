-- Main module
---@class Draft
local draft = {}

---@param opts table the plugin options, configured by user
function draft.setup(opts)
	local setup = require("draft.config").init(opts).setup

	if setup.core then
		-- load core module according to user configuration
		require("draft.core").init()
	end
	if setup.typography then
		-- load typography module according to user configuration
		require("draft.typography").setup()
	end
end

return draft
