local M = {}

local draft_ns = vim.api.nvim_create_namespace("draft")

-- PERF: Set only for viusal lines?
function M.update_indent(buf)
	vim.api.nvim_buf_clear_namespace(buf, draft_ns, 0, -1)
	for i = 0, vim.api.nvim_buf_line_count(buf) - 1 do
		vim.api.nvim_buf_set_extmark(buf, draft_ns, i, 0, {
			virt_text = { { "  ", "NonText" } },
			virt_text_pos = "inline",
			hl_mode = "combine",
		})
	end
end

function M.update_syntax()
	vim.api.nvim_set_hl(0, "Quote", { italic = true })
	vim.fn.matchadd("Quote", '"[^"]\\+"') -- quotes
	vim.fn.matchadd("Quote", "—[^—]*\\(—\\|$\\)") -- dialogues

	vim.fn.matchadd("Comment", "^\t.*") -- lines start with tab
	vim.fn.matchadd("Underlined", "^ .* $") -- lines start with space
	-- vim.fn.matchadd("Title", "^ .*") -- NOTE: started by space
	-- vim.fn.matchadd("Underlined", [[^\u.*[^.]$]]) -- NOTE: Started by vappital letter and no ended by dot
	-- TODO: Special color for actual editing line.
end

return M
