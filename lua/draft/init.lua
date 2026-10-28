-- Sprawdzenie lub automatyczna instalacja parsera (opcjonalnie, jeśli chcesz, żeby plugin sam dbał o .so)
local function ensure_parser()
	-- Neovim szuka parserów w vim.opt.runtimepath z podkatalogiem "parser/{lang}.so"
	-- Możesz sprawdzić, czy plik istnieje w katalogu konfiguracyjnym nvim:
	local parser_dir = vim.fn.stdpath("config") .. "/parser"
	local parser_path = parser_dir
		.. "/draft."
		.. (jit.os == "Windows" and "dll" or (jit.os == "OSX" and "dylib" or "so"))

	if vim.fn.filereadable(parser_path) == 0 then
		-- Opcjonalnie: możesz poinformować użytkownika lub spróbować skopiować,
		-- ale zazwyczaj po prostu zakłada się, że użytkownik umieścił plik w parser/
	end
end

local function native_treesitter_register()
	-- 1. Powiązanie rozszerzenia pliku z filetype "draft"
	vim.filetype.add({
		extension = {
			draft = "draft", -- pliki *.draft będą miały filetype "draft"
		},
	})

	-- 2. Natywne włączenie podświetlania / parsowania dla filetype "draft"
	-- (Neovim sam znajdzie plik draft.so w folderze runtimepath/parser/draft.so)
	vim.treesitter.language.register("draft", "draft")
end

-- Main module
---@class Draft
local draft = {}

---@param opts table Options configured by user
function draft.setup(opts)
	local config = require("draft.config").setup(opts).configuration

	if config.nvim_treesitter_integration then
		-- Zmieniamy na natywną rejestrację
		native_treesitter_register()
	end

	if config.core then
		require("draft.core").setup()
	end
	if config.typography then
		require("draft.typography").setup()
	end
end

return draft
