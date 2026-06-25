return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"mason-org/mason.nvim",
			opts = {
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			},
		},
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"graphql",
				},
				-- mason-lspconfig 2.x auto-enables installed servers via vim.lsp.enable().
				-- Set this to false if you'd rather enable them manually.
				automatic_enable = true,
			},
		},
	},
	config = function()
		-- Per-server customization (the modern API; merges over nvim-lspconfig's
		-- defaults in its lsp/ directory).
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		})

		-- GraphQL server provides code actions / hover / completion for .graphql
		-- and .gql files. Restrict to graphql filetypes so it doesn't attach to
		-- every JS/TS buffer (where it would also require a graphql.config file).
		vim.lsp.config("graphql", {
			filetypes = { "graphql", "graphqls" },
		})

		-- Buffer-local keymaps once a server attaches.
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = "LSP: " .. desc })
				end

				-- Telescope's lsp_definitions jumps directly on a single result and
				-- opens a picker when there are multiple.
				map("grd", require("telescope.builtin").lsp_definitions, "[G]oto Definition")
				map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ctions")
				map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("K", vim.lsp.buf.hover, "Hover")
			end,
		})

		-- Diagnostic config
		vim.diagnostic.config({
			severity_sort = true,
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
			float = {
				border = "rounded",
				wrap = true,
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			},
		})
	end,
}
