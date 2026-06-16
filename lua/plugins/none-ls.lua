return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local sources = {
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.prettierd,
      -- diagnostics
      require("none-ls.diagnostics.eslint").with({
        extra_filetypes = { "graphql" }
      }),
      -- code actions
      require("none-ls.code_actions.eslint").with({
        extra_filetypes = { "graphql" }
      })
    }

    null_ls.setup({
      sources,
    })

    vim.keymap.set("n", "<leader>fbb", vim.lsp.buf.format, { desc = "Format Buffer" })
    -- Format on save
    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      pattern = '*',
      callback = function()
        vim.lsp.buf.format { async = false }
      end,
    })
  end,
}
