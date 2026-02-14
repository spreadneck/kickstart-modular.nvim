# spreadneck's nvim config

> Summary: 23 plugins managed via lazy.nvim · 1,196 lines of Lua · Mini-centric UX with opinionated defaults

Personal Neovim build focused on speed, zero fluff, and a consistent DX across machines. I keep it public for my own convenience—feel free to peek, but there are no guarantees it fits any workflow other than mine.

## Highlights

- **Mini-first UX** – mini.pick for fuzzy finding, mini.clue for key hints, mini.basics for core editor tweaks, and a custom Mini UI module that reuses the Hybrid palette for mini.statusline + mini.tabline.
- **Lean completion + LSP** – blink.cmp + LuaSnip backed by `lazydev` and `nvim-lspconfig` with auto-install via Mason.
- **Tiling terminal friendly** – no GUI assumptions, relies on Nerd Font plus CLI tools (`rg`, `fd`, `git`, etc.).
- **User overrides** – drop any extra Lazy specs into `lua/user/plugins/` without touching the core stack.

## Requirements

| Tool | Notes |
| --- | --- |
| Neovim ≥ 0.10 | Nightly works, but this config follows stable APIs. |
| `git`, `make`, C toolchain | Needed for lazy.nvim bootstrap + plugin builds (LuaSnip’s regexp, Treesitter parsers). |
| [`ripgrep`](https://github.com/BurntSushi/ripgrep) & [`fd`](https://github.com/sharkdp/fd) | Picker backends. |
| Nerd Font | For symbols in statusline, diagnostics, etc. |
| Language toolchains | Install whatever runtimes you need (npm, Go, etc.). |

## Directory Map

```
~/.config/nvim/
├── init.lua                -- entry point (leader, bootstrap, lazy setup)
├── lua/
│   ├── core/
│   │   ├── options.lua     -- opt/gopt helpers via core.utils.vim_opts
│   │   ├── keymaps.lua     -- global mappings (window/nav/diagnostics)
│   │   ├── utils.lua       -- reusable helpers (vim_opts, collect_specs, ...)
│   │   └── plugins/
│   │       ├── init.lua    -- collects first-class plugin specs
│   │       ├── mini/…      -- Mini ecosystem (ui/pick/clue/hipatterns/basics helpers)
│   │       ├── treesitter.lua
│   │       ├── lspconfig.lua
│   │       ├── blink-cmp.lua
│   │       ├── conform.lua
│   │       └── lint.lua
│   ├── user/
│   │   └── plugins/        -- optional extras (Neogit, zk, render-markdown, etc.)
│   ├── lazy-bootstrap.lua  -- installs lazy.nvim if missing
│   └── lazy-plugins.lua    -- composes core + user specs and calls lazy.setup
└── README.md
```

## Plugin Stack Overview

### Core

| Module | Purpose |
| --- | --- |
| `core.plugins.mini` | Loads the base Mini modules (`ai`, `surround`, `files`, `pairs`, etc.) plus bespoke setups for the Hybrid UI, clue, hipatterns, pick. |
| `core.plugins.treesitter` | Syntax/indent with `ensure_installed` for common languages. |
| `core.plugins.lspconfig` | Sets up `lazydev`, `lua_ls`, shared LSP keymaps, diagnostics, and Mason tooling. |
| `core.plugins.blink-cmp` | Completion engine with LuaSnip + lazydev integration and `super-tab` keymap preset. |
| `core.plugins.conform` | Formatting with per-filetype config (`stylua`, `mdformat` for markdown). |
| `core.plugins.lint` | `nvim-lint` + autocmds for markdown/json linting. |

#### Mini Submodules

- `mini.ai`: Context-aware text objects.
- `mini.surround`: Surround operations.
- `mini.files`: File explorer.
- `mini.pairs`: Auto-pairing of brackets and quotes.
- `mini.bufremove`: Buffer removal.
- `mini.indentscope`: Indentation scope highlighting.
- `mini.notify`: Notification system.
- `mini.trailspace`: Trailing space highlighting.
- `mini.icons`: Icon support for various filetypes and UI elements.
- `mini.diff`: Git diff support.
- `mini.git`: Git integration.
- `mini.comment`: Commenting operations.
- `mini.extra`: Extra utilities.
- `mini.basics`: Default options/autocmds/mappings the rest of the stack builds on.
- `mini.hipatterns`: Highlights common patterns (TODO/FIXME, hex colors).
- `mini.clue`: Keybinding hints for leader sequences and built-in commands.
- `mini.pick`: Fuzzy finder with built-in pickers (files, grep, buffers, diagnostics, etc.).
- `mini.statusline`: Statusline with Hybrid color scheme.
- `mini.tabline`: Tabline with Hybrid color scheme.
- `mini.colors`: Color utilities.
- `mini.base16`: Base16 color scheme support.

#### LSP Config

- `lazydev`: enriches Lua language intelligence by preloading Neovim runtime types and keeping `lua_ls` aware of config/plugin files.
- `nvim-lspconfig`: core LSP client setup with buffer-local keymaps, diagnostic styling, autocommands for highlights/inlay hints, and Mason integration.
- `mason.nvim` + `mason-lspconfig.nvim` + `mason-tool-installer.nvim`: ensure servers (`lua_ls`, future entries) plus formatters (e.g., `stylua`, `mdformat`, `mdformat-frontmatter`) are installed automatically.
- `j-hui/fidget.nvim`: lightweight status indicator to surface LSP progress without cluttering the UI.

### User Layer (`lua/user/plugins/`)

- `neogit`: Lazy-loads Neogit with MiniPick integration.
- `oatmeal`: Wraps `dustinblackman/oatmeal.nvim` with `<leader>om` binding.
- `render-markdown`: Treesitter-aware markdown renderer.
- `zk`: Rich keymap suite for `zk-nvim` (notes, backlinks, journals).
- `init.lua`: collects all user modules with `core.utils.collect_specs`, so dropping a new file that exposes `config()` auto-adds it.

## Bootstrapping / Upgrading

1. **Fresh clone**
   ```sh
   git clone git@github.com:<you>/nvim ~/.config/nvim
   nvim
   ```
   Lazy installs itself via `lua/lazy-bootstrap.lua`, then syncs all specs.

2. **Updates**
   ```vim
   :Lazy sync
   ```
   Use `:Lazy clean` after large refactors to remove retired plugins.

3. **Adding user plugins**
   - Create `lua/user/plugins/foo.lua` returning `local M = {}; function M.config() return { ... } end`.
   - `lua/user/plugins/init.lua` already aggregates via `collect_specs`, so no extra wiring needed.

## Keymaps

Most bindings live in `lua/core/keymaps.lua` (window navigation, diag toggles). MiniPick adds its own search suite in `core/plugins/mini/pick.lua`. Highlights:

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>e` | Normal | `MiniFiles.open()` |
| `<leader>sf` / `sg` / `sh` / `ss` | Normal | Files / live grep / help / select pickers (MiniPick) |
| `<leader>sd` / `<leader>s.` / `<leader>sr` | Normal | Diagnostics / oldfiles / resume pick |
| `<leader>/` / `<leader>s/` | Normal | Search current buffer / all open buffers |
| `<leader>gg` | Normal | `:Neogit` |
| `<leader>om` | Normal | Launch Oatmeal session |
| `<BS>` | Normal | Alternate buffer |
| `<leader>zn`, `zd`, … | Normal/Visual | ZK commands (see `user/plugins/zk.lua` for full list) |

## Customization Notes

- **Options**: use `core/utils.vim_opts` to bulk-apply changes in `lua/core/options.lua` or any module.
- **Spec collection**: `core/utils.collect_specs` flattens modules—use it if you add plugin groups elsewhere.
- **Mini modules**: If a Mini submodule needs non-default config, remove it from the simple loop in `core/plugins/mini/init.lua` and add a dedicated setup call below the loop (or extend `core/plugins/mini/ui.lua` for visual tweaks).
- **Keymaps**: Keep global mappings in `core/keymaps.lua`. Plugin-specific mappings belong near their plugin spec to avoid cross-file hunting.

## Troubleshooting

| Issue | Fix |
| --- | --- |
| `module 'mini.xxx' not found` | Ensure the plugin is added to the simple Mini loop or required after `mini.nvim` loads (see clue fix). |
| Invalid plugin spec errors | Usually happens when a module returns `{ config = function... }` instead of a spec list—use `collect_specs`. |
| ShaDa permission errors in headless mode | Neovim needs write access to `~/.local/state/nvim/shada`. Adjust perms if running inside restricted containers. |
| LuaSnip log warnings | Ignore unless you need snippet debug logs; the config doesn’t set a custom log path. |

## License / Usage

MIT. No support provided—fork and adapt at your own risk.

If you break something, check `:Lazy doctor` and `:checkhealth`. Everything else lives in the code.
