local M = {}

M.name = "draft"

-- Sprawdza, czy provider ma działać dla danego bufora
function M.supports_buffer(bufnr)
	return vim.bo[bufnr].filetype == "draft"
end

-- Opcjonalne: Status wyświetlany w :OutlineStatus
function M.get_status()
	return { "Draft Treesitter Provider Active" }
end

-- Główna funkcja zbierająca symbole
function M.request_symbols(callback, opts)
	opts = opts or {}
	local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
	vim.notify("Draft provider: request_symbols wywołane dla bufora " .. bufnr, vim.log.levels.INFO)
	-- 1. Pobierz parser Tree-sittera dla bufora
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "draft")
	if not ok or not parser then
		vim.notify("Draft provider: Nie znaleziono parsera Tree-sitter dla 'draft'!", vim.log.levels.WARN)
		callback({}, opts)
		return
	end

	local tree = parser:parse()[1]
	if not tree then
		callback({}, opts)
		return
	end

	local root = tree:root()

	-- 2. Pobierz zapytanie z queries/draft/tags.scm (Neovim ładuje je automatycznie po nazwie filetype)
	local query_ok, query = pcall(vim.treesitter.query.get, "draft", "tags")
	if not query_ok or not query then
		vim.notify(
			"Draft provider: BŁĄD! Nie udało się załadować zapytań z queries/draft/tags.scm",
			vim.log.levels.ERROR
		)
		callback({}, opts)
		return
	else
		vim.notify("Draft provider: Zapytanie tags.scm załadowane pomyślnie!", vim.log.levels.INFO)
	end
	--

	--
	local symbols = {}
	local match_count = 0

	-- 3. Wykonaj zapytanie na drzewie AST i sformatuj wyniki
	for _, match, metadata in query:iter_matches(root, bufnr, 0, -1) do
		match_count = match_count + 1
		local name, node, range

		-- Odczytujemy capture @name oraz @definition.* z Twojego pliku tags.scm
		for id, nodes in pairs(match) do
			local capture_name = query.captures[id]
			if capture_name == "name" then
				-- Jeśli nodes to tablica lub pojedynek węzeł
				node = type(nodes) == "table" and nodes[1] or nodes
				name = vim.treesitter.get_node_text(node, bufnr)
			elseif capture_name:match("^definition") then
				local def_node = type(nodes) == "table" and nodes[1] or nodes
				local start_row, start_col, end_row, end_col = def_node:range()
				range = {
					start = { line = start_row, character = start_col },
					["end"] = { line = end_row, character = end_col },
				}
			end
		end

		-- Jeśli znaleźliśmy nazwę i zakres, dodajemy do listy symboli
		if name and range then
			vim.notify("Symbol: " .. name .. " [linia " .. range.start.line .. "]", vim.log.levels.INFO)
			table.insert(symbols, {
				name = name,
				kind = 12, -- Kod typu ikony (np. 12 to funkcja)
				selectionRange = range,
				range = range,
				children = {},
				detail = "draft section", -- Opcjonalny opis
			})
		end
	end
	vim.notify("Draft provider: Znaleziono pasujących węzłów: " .. match_count, vim.log.levels.INFO)
	vim.notify("Wszystkich symboli do przekazania: " .. #symbols, vim.log.levels.INFO)
	-- 4. Zwróć tablicę symboli do outline.nvim przez callback
	callback(symbols, opts)
end

return M
