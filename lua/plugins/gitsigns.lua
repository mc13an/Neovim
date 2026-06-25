return {
	"lewis6991/gitsigns.nvim",
	opts = {
		on_attach = function(buff)
			local gitsigns = require("gitsigns")

			local map = function(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = buff
				vim.keymap.set(mode, l, r, opts)
			end
			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end)

			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end)

			map("n", "<leader>hd", gitsigns.diffthis, { desc = "Git [D]iff this" })

			map("n", "<leader>hD", function()
				gitsigns.diffthis("~")
			end, { desc = "git [D]iff against last commit" })

			map("n", "<leader>hb", gitsigns.blame_line, { desc = "Git show line [b]lame" })
		end,
	},
}
