---@class Draft
local draft = {}

function draft.init_filetype()
	vim.filetype.add({
		extension = {
			draft = "draft",
		},
	})
end

---@param opts table
function draft.setup(opts)
	local config = require("draft.config").setup(opts).configuration

	if config.core then
		require("draft.core").setup()
	end
	if config.paginator then
		require("draft.paginator").setup()
	end
	if config.typography then
		require("draft.typography").setup()
	end
end

return draft
