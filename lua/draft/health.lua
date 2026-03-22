local function check_nvim_version()
	local v = vim.version()
	if v.major == 0 and v.minor >= 10 and v.patch >= 0 then
		vim.health.ok("neovim version >= 0.10.0")
	else
		vim.health.warn("neovim version < 0.10.0")
	end
end

local function is_defined_filetype(ft)
	return vim.tbl_contains(vim.fn.getcompletion("", "filetype"), ft)
end

local valid = require("draft.validator")
local options = require("draft.config").options

local function check_filetypes_config()
	vim.health.start("associated filetypes")
	local filetypes = options.filetypes
	if not next(filetypes) then
		vim.health.error("any filetype associated with plugin", "Fix configuration")
		return
	end
	for _, ft in ipairs(filetypes) do
		if is_defined_filetype(ft) then
			vim.health.ok(ft)
		else
			vim.health.warn(
				ft .. " - no defined",
				"Define this type in your nvim config or remove from plugin configurtion."
			)
		end
	end
end

local function check_loaded(name)
	if package.loaded[name] then
		vim.health.ok(name .. " loaded")
	else
		vim.health.info(name)
	end
end

local M = {}
M.check = function()
	check_loaded("draft")
	check_loaded("draft.core")
	check_loaded("draft.core.auto_repleace")
	check_loaded("draft.core.visual_move_keys")

	check_loaded("draft.decorator")
	check_loaded("draft.decorator.line")
	check_loaded("draft.decorator.paragrapher")
	check_loaded("draft.decorator.headliner")
	check_loaded("draft.decorator.hl_comment")
	check_loaded("draft.decorator.hl_dialogue")
	check_loaded("draft.decorator.hl_quote")
	check_loaded("draft.decorator.indenter")

	check_loaded("draft.paginator")
	check_loaded("draft.paginator.commands")

	vim.health.start("draft requirements")
	check_nvim_version()
	vim.health.start("draft configuration")
	check_filetypes_config()
end
return M
