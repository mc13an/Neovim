return {
  {
    'nvim-mini/mini.surround',
    version = '*',
    config = function()
      require('mini.surround').setup()
    end
  },
  {
    "nvim-mini/mini.animate",
    version = "*",
    config = function()
      require("mini.animate").setup()
    end
  },
  {
    "nvim-mini/mini.icons",
    version = "*",
    lazy = false,
    config = function()
      require("mini.icons").setup()
      -- so plugins expecting nvim-web-devicons (telescope, etc.) get icons too
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
  {
    'nvim-mini/mini.files',
    version = '*',
    config = function()
      local mini = require("mini.files")
      vim.keymap.set('n', '<leader>fm', function()
        mini.open(vim.api.nvim_buf_get_name(0))
      end, { desc = "[F]ile [M]andager" })
      mini.setup({
        mappings = {
          go_in_plus = "<CR>"
        }
      })
    end
  },
}
