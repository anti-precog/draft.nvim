local function check_nvim_version()
	local v = vim.version()
	if v.major == 0 and v.minor >= 10 and v.patch >= 0 then
		vim.health.ok("neovim version >= 0.10.0")
	else
		vim.health.warn("neovim version < 0.10.0")
	end
end

local function check_draft_filetype()
	local ft_patterns = vim.filetype.match({ filename = "test.draft" })

	if ft_patterns == "draft" or vim.tbl_contains(vim.fn.getcompletion("draft", "filetype"), "draft") then
		vim.health.ok("draft filetype is registered")
	else
		vim.health.warn(
			"draft filetype not found",
			"Make sure you have set up a filetype detector for '*.draft' files."
		)
	end
end

local config = require("draft.config")

---@type Config
local setup = config.setup

local function check_draft_parser()
	if config.has_parser then
		vim.health.ok("draft paser found")
	else
		vim.health.warn("draft parser not found")
	end
end

local M = {}
M.check = function()
	vim.health.start("draft requirements")
	check_nvim_version()
	check_draft_filetype()
	check_draft_parser()
end
return M
