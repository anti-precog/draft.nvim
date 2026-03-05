local M = {}

-- TODO: Refactor/Optimize
function open_page(direction)
	direction = direction or 1
	local current_file = vim.fn.expand("%:t")
	local current_dir = vim.fn.expand("%:p:h")

	if current_file == "" then
		print("There is no this part")
		return
	end

	local new_file = current_file:gsub("(%d+)", function(n)
		local new_num = tonumber(n) + direction
		if new_num < 0 then
			new_num = 0
		end
		return tostring(new_num)
	end, 1)

	local full_path = current_dir .. "/" .. new_file

	vim.cmd("argadd " .. full_path)
	vim.cmd("edit " .. full_path)

	print("Utworzono / przeszedł do pliku: " .. full_path)
end

local function get_number()
	local filename = vim.fn.expand("%:t") -- np. "23-scene.draft"
	local num = filename:match("(%d+)") -- "23" jako string
	num = tonumber(num) -- konwertuj na liczbę
	return num
end

local function go_to_page(num)
	local current_file = vim.fn.expand("%:t")
	local current_dir = vim.fn.expand("%:p:h")

	local target_file = current_file:gsub("(%d+)", tostring(num), 1)
	local full_path = current_dir .. "/" .. target_file

	vim.cmd("argadd " .. full_path)
	vim.cmd("edit " .. full_path)

	print("Loaded file: " .. target_file)
end

vim.api.nvim_create_user_command("GotoPage", function(opts)
	local num = tonumber(opts.args)
	if not num then
		print("Give correct number of file.")
		return
	end
	go_to_page(num)
end, {
	nargs = 1,
	desc = "Create or open a file with selected number",
})

vim.api.nvim_create_user_command("NextPage", function()
	page_num = get_number()
	if not page_num then
		print("No page number")
		return
	end
	go_to_page(page_num + 1)
end, {
	desc = "Go to next page",
})

vim.api.nvim_create_user_command("PrevPage", function()
	page_num = get_number()
	if not page_num then
		print("No page number")
		return
	elseif page_num == 0 then
		print("You are on zero page")
		return
	end
	go_to_page(page_num - 1)
end, {
	desc = "Go to prev page",
})

return M
