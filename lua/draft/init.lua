---@class draft
local draft = {}

---@param opts table
function draft.setup(opts)
	local valid = require("draft.config").setup(opts).valid

	if valid.core then
		require("draft.core").setup()
	end
	if valid.paginator then
		require("draft.paginator").setup()
	end
	if valid.decorator then
		require("draft.decorator").setup()
	end
end

return draft
