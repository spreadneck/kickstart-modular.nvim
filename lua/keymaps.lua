-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Quickly jump back to the alternate buffer
vim.keymap.set('n', '<BS>', '<cmd>edit #<cr>', { desc = 'Go to alternate buffer' })

local function call_minipick(fn)
  return function()
    local ok, pick = pcall(require, 'mini.pick')
    if not ok then
      vim.notify('mini.pick is not available', vim.log.levels.ERROR)
      return
    end
    return fn(pick)
  end
end

local function call_miniextra(fn)
  return function()
    local ok, extra = pcall(require, 'mini.extra')
    if not ok or extra.pickers == nil then
      vim.notify('mini.extra pickers are not available', vim.log.levels.ERROR)
      return
    end
    return fn(extra.pickers)
  end
end

-- Search pickers powered by mini.pick / mini.extra
vim.keymap.set('n', '<leader>sh', call_minipick(function(pick)
  pick.builtin.help()
end), { desc = '[S]earch [H]elp' })

vim.keymap.set('n', '<leader>sk', call_miniextra(function(pickers)
  pickers.keymaps()
end), { desc = '[S]earch [K]eymaps' })

vim.keymap.set('n', '<leader>sf', call_minipick(function(pick)
  pick.builtin.files()
end), { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>ss', call_minipick(function(pick)
  pick.registry.registry()
end), { desc = '[S]earch [S]elect Picker' })

vim.keymap.set('n', '<leader>sw', call_minipick(function(pick)
  pick.builtin.grep { pattern = vim.fn.expand '<cword>' }
end), { desc = '[S]earch current [W]ord' })

vim.keymap.set('n', '<leader>sg', call_minipick(function(pick)
  pick.builtin.grep_live()
end), { desc = '[S]earch by [G]rep' })

vim.keymap.set('n', '<leader>sd', call_miniextra(function(pickers)
  pickers.diagnostic()
end), { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<leader>sr', call_minipick(function(pick)
  pick.builtin.resume()
end), { desc = '[S]earch [R]esume' })

vim.keymap.set('n', '<leader>s.', call_miniextra(function(pickers)
  pickers.oldfiles()
end), { desc = '[S]earch Recent Files ("." for repeat)' })

vim.keymap.set('n', '<leader><leader>', call_minipick(function(pick)
  pick.builtin.buffers()
end), { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>/', call_miniextra(function(pickers)
  pickers.buf_lines { scope = 'current' }
end), { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>s/', call_miniextra(function(pickers)
  pickers.buf_lines { scope = 'all' }
end), { desc = '[S]earch [/] in Open Files' })

vim.keymap.set('n', '<leader>sn', call_minipick(function(pick)
  pick.builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })
end), { desc = '[S]earch [N]eovim files' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
