# CyberMini (personal setup)

This is my own Neovim config. I keep it public so I can sync it across machines, but it’s not intended to be a “starter” for anyone else. Expect hard-coded defaults, opinionated keymaps, and zero compatibility guarantees.

> Note: if you borrow anything here, you’re on your own. I don’t support other setups.

## Requirements (for myself)
- Neovim 0.10+
- `git`, `make`, `gcc`
- [`ripgrep`](https://github.com/BurntSushi/ripgrep) + [`fd`](https://github.com/sharkdp/fd)
- Nerd Font
- Whatever language toolchains I’m actively using (npm, go, etc.)

## Layout
```
lua/
├── core/
│   ├── options.lua
│   ├── keymaps.lua
│   └── plugins/
│       └── mini/...
├── plugins/
│   └── user/
├── lazy-bootstrap.lua
└── lazy-plugins.lua
```
- `core/`: always-on config and first-class plugins
- `plugins/user/`: drop-in Lazy specs (automatically imported)

## Mini stack
- `mini.basics`: options, toggles, autocommands
- `mini.pick`: unified picker UI (with fuzzy matching + preview) + keymaps
- `mini.clue`: which-key replacement (popup anchored bottom-left)
- `mini.hipatterns`: highlights for TODO/FIXME + hex colors
- `mini.statusline`: custom layout with git/lsp info
- Other modules: files, pairs, bufremove, indentscope, notify, etc.

## Other Plugins
- `treesitter`: syntax highlighting
- `lspconfig` + `lazydev`, `mason`: language server setup
- `blink.cmp`: completion with LuaSnip/friendly-snippets
- `conform`: formatting
- `nvim-lint`: linting
- User extras (under `plugins/user/`): Hybrid colorscheme, Neogit, render-markdown, zk, etc.

## Keymaps
Core maps live in `lua/core/keymaps.lua`. Highlights:
- `<leader>sf` / `<leader>sg` / `<leader>sh` / `<leader>ss`: MiniPick search suite
- `<leader>sd` / `<leader>s.` / `<leader>sr`: diagnostics, recent files, resume
- `<leader>/`: search current buffer (`mini.extra`)
- `<leader><leader>`: buffers
- `<leader>e`: MiniFiles
- `<leader>gg`: Neogit
- `<BS>`: alternate buffer

## Maintenance
- `:Lazy sync` after pulling
- `:Lazy clean` to prune removed plugins
- Add new specs under `lua/plugins/user/` (return a table or list)
- Keymaps/autocmds belong either in `core/keymaps.lua` or inside the plugin module

## License
MIT
