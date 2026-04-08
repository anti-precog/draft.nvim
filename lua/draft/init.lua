local function nvim_treesitter_integrate()
	local parsers = require("nvim-treesitter.parsers")
	local parsers_config = parsers.get_parser_configs()

	parsers_config.draft = {
		install_info = {
			url = "https://github.com/anti-precog/tree-sitter-draft",
			files = { "src/parser.c" },
			branch = "main",
		},
		filetype = "draft",
	}

	if not parsers.has_parser("draft") then
		vim.cmd("TSInstall draft")
	end
end

-- Main moduel
---@class Draft
local draft = {}

---@param opts table Options configured by user
function draft.setup(opts)
	local config = require("draft.config").setup(opts).configuration

	if config.nvim_treesitter_integration then
		nvim_treesitter_integrate()
	end

	if config.core then
		require("draft.core").setup()
	end
	if config.typography then
		require("draft.typography").setup()
	end
end

return draft
