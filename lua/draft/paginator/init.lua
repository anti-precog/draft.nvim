local conf = require("draft.config").options

-- a module for quickly jumping through files in the project
---@class paginator
local M = {}

-- init module
---@param opts options|nil
---@return paginator
function M.setup(opts)
	if opts then
		conf = require("draft.config").setup(opts).options
	end

	local group = vim.api.nvim_create_augroup("draft-nav", { clear = true })

	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = group,
		pattern = conf.filetypes,
		callback = function()
			require("draft.paginator.commands").setup()
		end,
		desc = "activate drafts navigator",
	})
	return M
end

return M
