return {
	"romgrk/barbar.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "lewis6991/gitsigns.nvim" },
	init = function()
		vim.g.barbar_auto_setup = true
	end,
	config = function()
		local map = vim.keymap.set
		-- Barbar moves between *buffers*, not tab pages, so remap gt/gT here.
		map("n", "gt", "<Cmd>BufferNext<CR>", { desc = "Go to next buffer" })
		map("n", "gT", "<Cmd>BufferPrevious<CR>", { desc = "Go to previous buffer" })
		map("n", "<A-l>", "<Cmd>BufferNext<CR>", { desc = "Go to next buffer" })
		map("n", "<A-h>", "<Cmd>BufferPrevious<CR>", { desc = "Go to previous buffer" })
		map("n", "]]", "<Cmd>BufferNext<CR>", { desc = "Go to previous buffer" })
		map("n", "[[", "<Cmd>BufferPrevious<CR>", { desc = "Go to previous buffer" })
	end,
}
