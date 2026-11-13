local config = require("draft.config")
---@type CoreConfig|boolean
local core_config = config.setup.core

-- Table of active core features
local active_features = {}

---@param feature fun() feature to activate
local function active(feature)
	table.insert(active_features, feature)
end

-- Neccesary vim setup to proper plugin operations
local function vim_setup()
	vim.opt_local.wrap = true
	vim.opt_local.linebreak = true
	vim.opt_local.breakindent = true
	vim.opt_local.conceallevel = 2
end

---@return boolean config_status status of core.auto_turn_page
local function is_page_navigator()
	return core_config.auto_turn_page
end

---@return boolean config_status status of core.move_by_visual_lines
local function is_wrap_navigator()
	return core_config.move_by_visual_lines
end

---@return boolean config_status check if all navigator features are active
local function is_full_navigator()
	return is_page_navigator() and is_wrap_navigator()
end

-- A core features module
---@class CoreModule
local M = {}

-- Init module
---@return CoreModule
function M.init()
	if core_config.repleace_dash then
		active(require("draft.core.auto_repleace").dash_keymap)
	end
	if core_config.repleace_ellipsis then
		active(require("draft.core.auto_repleace").ellipsis_keymap)
	end
	if core_config.smart_quotes then
		active(require("draft.core.auto_repleace").quotes_keymap)
	end
	if is_full_navigator() then
		local nav = require("draft.core.navigator")
		active(nav.commands)
		active(nav.try_turn_page_wrap_lines_keymaps)
	elseif is_page_navigator() then
		local nav = require("draft.core.navigator")
		active(nav.commands)
		active(nav.try_turn_page_keymaps)
	elseif is_wrap_navigator() then
		active(require("draft.core.navigator").wrap_lines_keymaps)
	end

	active(vim_setup)

	local group = vim.api.nvim_create_augroup("draft-core", { clear = true })
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = group,
		pattern = "draft",
		callback = function()
			for _, feature in ipairs(active_features) do
				feature()
			end

			if core_config.skip_meta_lines then
				local skipper = require("draft.core.skipper")
				vim.api.nvim_create_autocmd({ "CursorMoved" }, {
					group = group,
					pattern = "draft",
					callback = function()
						skipper.try_skip()
					end,
					desc = "load draft.core skipper",
				})
			end

			if core_config.info_bar then
				local status = require("draft.core.status")
				vim.api.nvim_create_autocmd({ "CursorMoved" }, {
					group = group,
					pattern = "draft",
					callback = function()
						status.redraw()
					end,
					desc = "load draft.core status",
				})
			end
		end,
		desc = "load draft.core improvements",
	})
	return M
end
return M
