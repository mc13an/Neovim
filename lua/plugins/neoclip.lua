return {
	"AckslD/nvim-neoclip.lua",
	dependencies = {
		-- you'll need at least one of these
		{ "nvim-telescope/telescope.nvim" },
		-- {'ibhagwan/fzf-lua'},
	},
	config = function()
		require("neoclip").setup({
			keys = {
				telescope = {
					i = {
						-- move paste off <c-p> so telescope's default
						-- move_selection_previous takes over that key
						paste = "<c-y>",
						paste_behind = "<c-k>",
					},
				},
			},
		})
		vim.keymap.set("n", "<leader>o", "<cmd>Telescope neoclip<CR>", { desc = "Telescope Neoclip" })
	end,
}
