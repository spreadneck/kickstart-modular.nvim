local M = {}

local components = {
  ui = require 'core.plugins.mini.ui',
  basics = require 'core.plugins.mini.basics',
  pick = require 'core.plugins.mini.pick',
  clue = require 'core.plugins.mini.clue',
  hipatterns = require 'core.plugins.mini.hipatterns',
}

local simple_modules = {
  'ai',
  'surround',
  'files',
  'pairs',
  'bufremove',
  'indentscope',
  'notify',
  'trailspace',
  'icons',
  'diff',
  'git',
  'comment',
  'extra',
}

function M.config()
  return {
    {
      'nvim-mini/mini.nvim',
      lazy = false,
      priority = 100,
      config = function()
        components.ui.setup()

        for _, plugin in ipairs(simple_modules) do
          require('mini.' .. plugin).setup()
        end

        -- Modules below carry extra configuration and therefore stay bespoke.
        components.basics.setup()
        components.ui.apply_statusline()
        components.clue.setup()
        components.hipatterns.setup()

        -- mini.pick needs custom setup and its own keymaps.
        components.pick.setup()
        components.pick.set_keymaps()
      end,
      init = function()
        -- Default toggle for MiniFiles so it is available before lazy-loading finishes.
        vim.keymap.set('n', '<leader>e', '<cmd>lua MiniFiles.open()<cr>', { desc = 'File Explorer' })
      end,
    },
  }
end

return M
-- vim: ts=2 sts=2 sw=2 et
