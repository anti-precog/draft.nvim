local M = {}

function M.setup(opts)
	local dash = opts.dash or "-"
	vim.keymap.set("i", dash, "—", { buffer = true })
end

return M
