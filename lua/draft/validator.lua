---@class validator
local M = {}

---@param tab any
---@return boolean
function M.has_values(tab)
	return type(tab) == "table" and next(tab) ~= nil
end

---@param tab table
---@param keys string[]
---@return boolean
function M.has_key(tab, keys)
	for _, key in ipairs(keys) do
		local val = tab[key]
		if type(val) == "string" then
			return true
		end
	end

	return false
end

---@param value any
---@return boolean
function M.is_positive(value)
	return type(value) == "number" and value > 0
end

---@param config table
---@return boolean
function M.config(config)
	return M.has_values(config.filetypes) and (config.dash == "—" or config.dash == "–")
end

---@param val any
---@param values table
function M.has_value(val, values)
	for _, v in ipairs(values) do
		if v == val then
			return true
		end
	end
	return false
end

function M.is_type_of(var, types)
	if types[type(var)] then
		return true
	end
	return false
end

---@param config table
---@return boolean
function M.core_config(config)
	return config.move_by_visual_lines
		or (M.has_values(config.auto_repleace_symbols) and M.has_key(config.auto_repleace_symbols, { "dash" }))
end

---@param config table
---@return boolean
function M.decorator_config(config)
	return M.is_positive(config.indent)
		or (M.has_values(config.syntax) and M.has_key(config.center, { "dialogue", "quote", "comment", "header" }))
		or (M.has_values(config.center) and M.has_key(config.center, { "header", "asterix" }))
end

---@param config table
---@return boolean
function M.navigator_config(config)
	return config.navigator
end

return M
