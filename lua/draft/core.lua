---@module "core"
local M = {}

M.keys = {
	emdash = nil,
	dash = nil,
}

local function setup_vim()
	vim.opt_local.wrap = true
	vim.opt_local.linebreak = true
	vim.opt_local.breakindent = true
end

function set_visual_move_keys()
	setup_vim()
	vim.keymap.set("n", "j", function()
		return vim.v.count == 0 and "gj" or "j"
	end, { expr = true, buffer = 0 })

	vim.keymap.set("n", "k", function()
		return vim.v.count == 0 and "gk" or "k"
	end, { expr = true, buffer = 0 })
end

function set_dash_key()
	vim.keymap.set("i", M.keys.dash, "–", { buffer = true })
end

function set_emdash_key()
	vim.keymap.set("i", M.keys.emdash, "—", { buffer = true })
end

---@param opts table
function M.setup(opts)
	-- filetypes {}
	-- move_by_visul_lines boolean
	-- auto_repleace_symbols boolean | {}

	local features = {}
	if opts.visual_move_keys then
		table.insert(features, set_visual_move_keys)
	end
	if opts.repleace_symbols then
		if opts.repleace_symbols.dash then
			M.keys.dash = opts.repleace_symbols.dash
			table.insert(features, set_dash_key)
		end
		if opts.repleace_symbols.emdash then
			M.keys.emdash = opts.repleace_symbols.emdash
			table.insert(features, set_emdash_key)
		end
	end

	local group = vim.api.nvim_create_augroup("draft-core", { clear = true })
	--	vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
	vim.api.nvim_create_autocmd({ "FileType" }, {
		group = group,
		-- NOTE: *.draft -> (BufEnter) draft -> (FileType)
		--pattern = { "draft", "*.draft" },
		pattern = opts.filetypes,
		callback = function()
			for _, func in ipairs(features) do
				func()
			end
		end,
		desc = "load draft.core settings",
	})
end
return M
