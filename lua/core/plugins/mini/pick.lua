local M = {}

local fuzzy = require 'core.plugins.mini.fuzzy'

local pick_cache
local extra_cache

local function get_pick()
  if pick_cache then
    return pick_cache
  end
  local ok, pick = pcall(require, 'mini.pick')
  if not ok then
    vim.notify('mini.pick is not available', vim.log.levels.ERROR)
    return nil
  end
  pick_cache = pick
  return pick_cache
end

local function get_extra_pickers()
  if extra_cache then
    return extra_cache.pickers
  end
  local ok, extra = pcall(require, 'mini.extra')
  if not ok or extra.pickers == nil then
    vim.notify('mini.extra pickers are not available', vim.log.levels.ERROR)
    return nil
  end
  extra_cache = extra
  return extra_cache.pickers
end

local function call_with(getter)
  return function(fn)
    return function()
      local module = getter()
      if not module then
        return
      end
      return fn(module)
    end
  end
end

local call_minipick = call_with(get_pick)
local call_miniextra = call_with(get_extra_pickers)

function M.setup()
  local minipick = get_pick()
  if not minipick then
    return
  end

  local match_fn = fuzzy.matcher(minipick)
  minipick.setup {
    source = {
      match = match_fn,
      preview = minipick.default_preview,
    },
  }

  local registry = minipick.registry
  registry.registry = function(local_opts)
    local items = {}
    for name in pairs(registry) do
      if name ~= 'registry' then
        table.insert(items, name)
      end
    end
    table.sort(items)
    return minipick.start {
      source = {
        items = items,
        name = 'MiniPick registry',
        choose = function(item)
          if not item then
            return
          end
          local picker = registry[item]
          if not picker then
            return
          end
          return picker(local_opts)
        end,
      },
    }
  end
end

function M.set_keymaps()
  local mappings = {
    {
      '<leader>sh',
      call_minipick(function(pick) pick.builtin.help() end),
      '[S]earch [H]elp',
    },
    {
      '<leader>sk',
      call_miniextra(function(pickers) pickers.keymaps() end),
      '[S]earch [K]eymaps',
    },
    {
      '<leader>sf',
      call_minipick(function(pick) pick.builtin.files() end),
      '[S]earch [F]iles',
    },
    {
      '<leader>ss',
      call_minipick(function(pick) pick.registry.registry() end),
      '[S]earch [S]elect Picker',
    },
    {
      '<leader>sw',
      call_minipick(function(pick) pick.builtin.grep { pattern = vim.fn.expand '<cword>' } end),
      '[S]earch current [W]ord',
    },
    {
      '<leader>sg',
      call_minipick(function(pick) pick.builtin.grep_live() end),
      '[S]earch by [G]rep',
    },
    {
      '<leader>sd',
      call_miniextra(function(pickers) pickers.diagnostic() end),
      '[S]earch [D]iagnostics',
    },
    {
      '<leader>sr',
      call_minipick(function(pick) pick.builtin.resume() end),
      '[S]earch [R]esume',
    },
    {
      '<leader>s.',
      call_miniextra(function(pickers) pickers.oldfiles() end),
      '[S]earch Recent Files',
    },
    {
      '<leader><leader>',
      call_minipick(function(pick) pick.builtin.buffers() end),
      'Find buffers',
    },
    {
      '<leader>/',
      call_miniextra(function(pickers) pickers.buf_lines { scope = 'current' } end),
      'Search current buffer',
    },
    {
      '<leader>s/',
      call_miniextra(function(pickers) pickers.buf_lines { scope = 'all' } end),
      'Search open files',
    },
    {
      '<leader>sn',
      call_minipick(function(pick)
        pick.builtin.files(nil, { source = { cwd = vim.fn.stdpath 'config' } })
      end),
      '[S]earch [N]eovim files',
    },
  }

  for _, mapping in ipairs(mappings) do
    vim.keymap.set('n', mapping[1], mapping[2], { desc = mapping[3] })
  end
end

return M
-- vim: ts=2 sts=2 sw=2 et
