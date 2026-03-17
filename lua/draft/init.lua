---@module "draft"
local M = {}

local defaults = {
	-- global
	modules = {
		core = true,
		navigator = true,
		deocrator = true,
	},
	filetypes = { "draft", "text" }, -- work only for those filetypes
	-- core
	move_by_visual_lines = true,
	auto_repleace_symbols = {
		emdash = "-",
		dash = "=",
	},
	-- navigator
	-- decorator
	indent = "    ",
	syntax = {
		dialogues = "Statement",
		quotes = "Statement",
		commants = "NonText",
		headers = "Statement",
	},
}

M.config = defaults

local function validate_core_opts()
	local is_auto_repleace_valid = M.config.auto_repleace_symbols
		and next(M.config.auto_repleace_symbols) ~= nil
		and (M.config.auto_repleace_symbols.dash or M.config.auto_repleace_symbols.emdash)

	return M.config.modules.core and (M.config.move_by_visual_lines or is_auto_repleace_valid)
end

local function validate_navigator_opts()
	return M.config.modules.navigator
end

local function validate_decorator_opts()
	local is_indent_valid = M.config.indent and M.config.indent ~= ""
	local is_syntax_valid = M.config.syntax
		and next(M.config.syntax) ~= nil
		and (M.config.syntax.dialogues or M.config.syntax.quotes or M.config.syntax.commants or M.config.syntax.headers)
	return M.config.modules.decorator and (is_indent_valid or is_syntax_valid)
end

---@param opts table
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", defaults, opts or {})

	if opts.filetypes and next(opts.filetypes) == nil then
		return
	end

	if validate_core_opts() then
		print("core loaded")
		require("draft.core").setup({
			filetypes = M.config.filetypes,
			visual_move_keys = M.config.move_by_visual_lines or nil,
			repleace_symbols = M.config.auto_repleace_symbols or nil,
		})
	end
	if validate_navigator_opts() then
		print("navigator loaded")
		require("draft.navigator").setup({
			filetypes = M.config.filetypes,
		})
	end
	--	if validate_decorator_opts() then
	print("decorator loaded")
	require("draft.decorator").setup({
		filetypes = M.config.filetypes,
		indent = M.config.indent or nil,
		syntax = M.syntax or nil,
	})
	--	end
end

return M
