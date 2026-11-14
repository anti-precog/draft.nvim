---@alias TSNode userdata -- to prevent diagnostics warning

-- Default options for all modules
---@class Config
---@field core table|boolean
---@field typography table|boolean
local defaults = {

	-- Configuration for core module
	---@class CoreConfig
	core = {
		repleace_dash = ">",
		repleace_ellipsis = "...",
		smart_quotes = true,
		move_by_visual_lines = true,
		auto_turn_page = true,
		skip_meta_lines = true,
		info_bar = true, -- WARN: Experimental feature
	},

	-- Configuration for typography module
	---@class TypographyConfig
	typography = {
		indent_size = 4,
		center_asterix = true,
		center_header = true,
		group_frames = true,
	},
}

--- Validate options before concatenate with defaults
---@param opts table the plugin options, configured by user
local function pre_validate(opts)
	vim.validate({
		core = { opts.core, { "table", "boolean" }, true },
		typography = { opts.typography, { "table", "boolean" }, true },
	})
end

---@class ConfigModule
local M = {}

-- Active modules & options
---@type Config
M.setup = defaults

-- Treesitter parser status for draft
M.has_parser = vim.treesitter.language.add("draft") and true or false

-- Validate options after concatenate with defaults
local function post_validate()
	if type(M.setup.core) == "table" then
		vim.validate({
			move_by_visual_lines = { M.setup.core.move_by_visual_lines, "boolean", false },
			smart_quotes = { M.setup.core.smart_quotes, "boolean", false },
			repleace_dash = { M.setup.core.repleace_dash, { "string", "boolean" }, false },
			repleace_ellipsis = { M.setup.core.repleace_ellipsis, { "string", "boolean" }, false },
			auto_turn_page = { M.setup.core.auto_turn_page, "boolean", false },
			info_bar = { M.setup.core.info_bar, "boolean", false },
			skip_meta_lines = { M.setup.core.skip_meta_lines, "boolean", false },
		})
	end

	if type(M.setup.typography) == "table" then
		vim.validate({
			indent_size = { M.setup.typography.indent_size, "number", false },
			center_header = { M.setup.typography.center_header, "boolean", false },
			center_asterix = { M.setup.typography.center_asterix, "boolean", false },
			group_frames = { M.setup.typography.group_frames, "boolean", true },
		})
	end
end

-- Concatenate user options with defaults
---@param opts table the plugin options, configured by user
local function concat_with_defaults(opts)
	M.setup = vim.tbl_deep_extend("force", defaults, opts)
end

---@type integer Global plugin namespace
M.namespace = vim.api.nvim_create_namespace("draft")

-- Init custom configuration
---@param opts Config
---@return ConfigModule
function M.init(opts)
	opts = opts or {}

	pre_validate(opts)
	concat_with_defaults(opts)
	post_validate()

	return M
end

return M
