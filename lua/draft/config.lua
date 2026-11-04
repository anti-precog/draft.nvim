---@alias TSNode userdata

---@class Config
---@field dash_symbol string
---@field core table|boolean
---@field typography table|boolean
local defaults = {
	-- select how to recognize dialogues as em-dash or en-dash
	dash_symbol = "em-dash", -- WARN: treesitter do not know about two versions

	-- Configuration for core module
	---@class CoreConfig
	core = {
		repleace_dash = "--",
		repleace_ellipsis = "...",
		smart_quotes = true,
		move_by_visual_lines = true,
		auto_turn_page = true,
		-- NOTE: required tree-sitter:
		skip_meta_lines = true, -- TODO: make it separatly for sections and groups
		info_bar = true, -- consider ro remove or improve for beter functionality
	},

	-- Configuration for typography module
	---@class TypographyConfig
	typography = {
		indent_size = 4,
		center_asterix = true,
		center_header = false,

		-- NOTE: required tree-sitter:
		group_frames = true,
	},
}

local function pre_validate(opts)
	vim.validate({
		dash_symbol = {
			opts.dash_symbol,
			function(v)
				return type(v) == "string" and (v == "em-dash" or v == "en-dash")
			end,
			true,
		},
		core = { opts.core, { "table, boolean" }, true },
		typography = { opts.typography, { "table", "boolean" }, true },
	})
end

---@class ConfigModule
local M = {}

---@type Config
M.configuration = defaults
M.has_parser = vim.treesitter.language.add("draft") and true or false

local function post_validate()
	if type(M.configuration.core) == "table" then
		vim.validate({
			move_by_visual_lines = { M.configuration.core.move_by_visual_lines, "boolean", false },
			smart_quotes = { M.configuration.core.smart_quotes, "boolean", false },
			repleace_dash = { M.configuration.core.repleace_dash, { "string", "boolean" }, false },
			repleace_ellipsis = { M.configuration.core.repleace_ellipsis, { "string", "boolean" }, false },
			auto_turn_page = { M.configuration.core.auto_turn_page, "boolean", false },
			info_bar = { M.configuration.core.info_bar, "boolean", false },
			skip_meta_lines = { M.configuration.core.skip_meta_lines, "boolean", false },
		})
	end

	if type(M.configuration.typography) == "table" then
		vim.validate({
			indent_size = { M.configuration.typography.indent_size, "number", false },
			center_header = { M.configuration.typography.center_header, "boolean", false },
			center_asterix = { M.configuration.typography.center_asterix, "boolean", false },
			group_frames = { M.configuration.typography.group_frames, "boolean", true },
		})
	end
end

local function concat_with_defaults(opts)
	M.configuration = vim.tbl_deep_extend("force", defaults, opts)
end

local function repleace_dash()
	if M.configuration.dash_symbol == "em-dash" then
		M.configuration.dash_symbol = "—"
	elseif M.configuration.dash_symbol == "en-dash" then
		M.configuration.dash_symbol = "–"
	end
end

---@type integer Global plugin namespace
M.namespace = vim.api.nvim_create_namespace("draft")

-- Init custom configuration
---@param opts Config
---@return ConfigModule
function M.setup(opts)
	opts = opts or {}

	pre_validate(opts)
	concat_with_defaults(opts)
	post_validate()
	repleace_dash()

	return M
end

return M
