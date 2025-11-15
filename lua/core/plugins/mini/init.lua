local M = {}
local pick = require 'core.plugins.mini.pick'
local statusline = require 'core.plugins.mini.statusline'
local clue = require 'core.plugins.mini.clue'
local hipatterns = require 'core.plugins.mini.hipatterns'

function M.config()
  return {
    {
      'nvim-mini/mini.nvim',
      lazy = false,
      priority = 100,
      config = function()
        -- Base modules that work with the default `.setup()`.
        local mini_plugins = {
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

        for _, plugin in ipairs(mini_plugins) do
          require('mini.' .. plugin).setup()
        end

        -- Modules below carry extra configuration and therefore stay bespoke.
        statusline.setup()
        clue.setup()
        hipatterns.setup()

        -- mini.pick needs custom setup and its own keymaps.
        pick.setup()
        pick.set_keymaps()
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
