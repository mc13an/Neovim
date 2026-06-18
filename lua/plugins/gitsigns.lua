return {
	"lewis6991/gitsigns.nvim",
	on_attach = function(buffer)
		local gitsigns = require("gitsigns")

		local map = function(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = buffer
			vim.keymap.set(mode, l, r, opts)
		end

		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "Git show line blame" })
	end,
}
