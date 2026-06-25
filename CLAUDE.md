# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim configuration managed by [lazy.nvim](https://github.com/folke/lazy.nvim). There is no build/test/lint step — changes are validated by launching Neovim and observing behavior.

## Structure & Loading

- `init.lua` — entry point. Sets editor options (2-space expandtab indent), leader keys (`<Space>` global, `\` local), bootstraps lazy.nvim into `stdpath("data")/lazy/lazy.nvim`, then calls `require("lazy").setup("plugins")`.
- `require("lazy").setup("plugins")` auto-imports **every** file under `lua/plugins/`. Each file returns a lazy.nvim plugin spec (a table, or a list of tables for multiple plugins). Adding a new plugin = adding a new file there; no central registry to update.
- `lazy-lock.json` — committed lockfile pinning plugin commits. Update via `:Lazy update`; commit the resulting changes.

## Working in this repo

- After editing a plugin spec, reload with `:Lazy reload` or restart Neovim. Manage plugins via `:Lazy` (install/update/sync), `:Mason` (LSP servers), `:TSUpdate` (treesitter parsers). `gb` inside `:Lazy` rebuilds a plugin (relevant for `blink.cmp`'s Rust fuzzy matcher and `telescope-fzf-native`'s `make` build).
- Keymaps live **inside the plugin spec that owns them** (in `config`/`keys`/`opts`), not in a shared keymaps file. To find or change a binding, edit the relevant `lua/plugins/*.lua`.

## Key architectural conventions

- **LSP** (`lsp-config.lua`): uses the modern `vim.lsp.config(...)` + `vim.lsp.enable()` API via mason-lspconfig 2.x (`automatic_enable = true`). Servers are auto-enabled once installed by Mason (`ensure_installed`: `lua_ls`, `ts_ls`, `graphql`). The `graphql` server is scoped to `graphql`/`graphqls` filetypes (covers `.graphql` and `.gql`) so it doesn't attach to JS/TS buffers. Buffer-local LSP keymaps (`grd`, `gra`, `grr`, `grn`, `K`) are set in an `LspAttach` autocmd, not globally.
- **Formatting & diagnostics** (`none-ls.lua`): none-ls (null-ls) provides `stylua`, `prettierd`, and `eslint` (diagnostics + code actions, extended to graphql). **Format-on-save is enabled globally** via a `BufWritePre` autocmd calling `vim.lsp.buf.format`. Edits to Lua files in this repo will be auto-formatted by stylua on save — expect formatting churn.
- **Completion**: `blink.cmp` (not nvim-cmp) with sources `lsp`, `path`, `snippets`, `buffer`. Default keymap preset (`C-y` to accept).
- **Buffers vs. tabs** (`barber.lua`): barbar manages the bufferline. `gt`/`gT` are remapped to move between **buffers**, not tab pages — keep this in mind when reasoning about navigation.
- **Icons** (`mini.lua`): `mini.icons` is used and mocks `nvim-web-devicons` so plugins expecting devicons still get icons. Several plugins also declare `nvim-web-devicons` as a dependency directly.
- **Theme**: tokyonight (`lazy = false`, `priority = 1000` so it loads first).

## Keymap reference

Leader is `<Space>`. Each binding is defined in the plugin file noted in the last column.

| Key | Action | Source |
|-----|--------|--------|
| `<leader>sf` | Telescope find files | `telescope.lua` |
| `<leader>sg` | Telescope live grep | `telescope.lua` |
| `<leader>sk` | Telescope keymap picker | `telescope.lua` |
| `<leader>?` | Buffer-local keymaps popup (which-key) | `which-key.lua` |
| `<leader><leader>` | Telescope buffers | `telescope.lua` |
| `<leader>fm` | Open mini.files at current file | `mini.lua` |
| `<leader>fbb` | Format buffer | `none-ls.lua` |
| `<leader>lg` | Open LazyGit | `lazygit.lua` |
| `<leader>hb` | Git blame current line | `gitsigns.lua` |
| `]c` / `[c` | Next / previous git hunk | `gitsigns.lua` |
| `<leader>xx` | Diagnostics (Trouble) | `trouble.lua` |
| `<leader>xX` | Buffer diagnostics (Trouble) | `trouble.lua` |
| `<leader>cs` | Symbols (Trouble) | `trouble.lua` |
| `<leader>cl` | LSP defs/refs (Trouble) | `trouble.lua` |
| `<leader>xL` | Location list (Trouble) | `trouble.lua` |
| `<leader>xQ` | Quickfix list (Trouble) | `trouble.lua` |
| `grd` | LSP go to definition (Telescope picker on multiple) | `lsp-config.lua` (LspAttach) |
| `gra` | LSP code action | `lsp-config.lua` (LspAttach) |
| `grr` | LSP references | `lsp-config.lua` (LspAttach) |
| `grn` | LSP rename | `lsp-config.lua` (LspAttach) |
| `K` | LSP hover | `lsp-config.lua` (LspAttach) |
| `gt` / `]]` / `<A-l>` | Next buffer (barbar) | `barber.lua` |
| `gT` / `[[` / `<A-h>` | Previous buffer (barbar) | `barber.lua` |
| `<CR>` (in mini.files) | Enter dir / open file (`go_in_plus`) | `mini.lua` |

**blink.cmp completion** (default preset): `C-y` accept · `C-space` open menu/docs · `C-n`/`C-p` (or `Up`/`Down`) select · `C-e` hide · `C-k` toggle signature help.
