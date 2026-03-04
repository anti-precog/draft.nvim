local M = {}

function M.hello()
	print("Hello! Plugin work!")
end

vim.api.nvim_create_user_command("HelloPlugin", function()
	M.hello()
end, {})

return M
