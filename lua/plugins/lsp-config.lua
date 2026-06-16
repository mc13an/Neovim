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

    -- Buffer-local keymaps once a server attaches.
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
        end

        map("grd", vim.lsp.buf.definition, "[G]oto Definition")
        map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ctions")
        map("grr", vim.lsp.buf.references, "[G]oto [R]eferences")
        map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("K", vim.lsp.buf.hover, "Hover")
      end,
    })
  end,
}
