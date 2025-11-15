local M = {}

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

function M.setup()
  local minipick = require 'mini.pick'
  local match_fn = require('core.plugins.mini.fuzzy')(minipick)

  minipick.setup {
    source = {
      match = match_fn,
      preview = minipick.default_preview,
    },
  }

  minipick.registry.registry = function(local_opts)
    local names = vim.tbl_keys(minipick.registry)
    table.sort(names)
    local items = vim.tbl_filter(function(name) return name ~= 'registry' end, names)
    local source = {
      items = items,
      name = 'MiniPick registry',
      choose = function(item)
        if item == nil then return end
        local picker = minipick.registry[item]
        if picker == nil then return end
        return picker(local_opts)
      end,
    }
    return minipick.start { source = source }
  end

  return minipick
end

function M.set_keymaps()
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
  end), { desc = '[S]earch Recent Files' })

  vim.keymap.set('n', '<leader><leader>', call_minipick(function(pick)
    pick.builtin.buffers()
  end), { desc = 'Find buffers' })

  vim.keymap.set('n', '<leader>/', call_miniextra(function(pickers)
    pickers.buf_lines { scope = 'current' }
  end), { desc = 'Search current buffer' })

  vim.keymap.set('n', '<leader>s/', call_miniextra(function(pickers)
    pickers.buf_lines { scope = 'all' }
  end), { desc = 'Search open files' })

  vim.keymap.set('n', '<leader>sn', call_minipick(function(pick)
    pick.builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })
  end), { desc = '[S]earch [N]eovim files' })
end

return M
