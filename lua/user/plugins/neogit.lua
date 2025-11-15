local M = {}

function M.config()
  return {
    {
      'NeogitOrg/neogit',
      lazy = true,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-mini/mini.pick',
      },
      cmd = 'Neogit',
      keys = {
        { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Show Neogit UI' },
      },
    },
  }
end

return M
-- vim: ts=2 sts=2 sw=2 et
