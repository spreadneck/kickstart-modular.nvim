local M = {}

function M.config()
  return {
    {
      'dustinblackman/oatmeal.nvim',
      cmd = { 'Oatmeal' },
      keys = {
        {
          '<leader>om',
          '<cmd>Oatmeal<CR>',
          mode = 'n',
          desc = 'Start Oatmeal session',
        },
      },
      opts = {},
      config = function(_, opts)
        require('oatmeal').setup(opts)
      end,
    },
  }
end

return M
-- vim: ts=2 sts=2 sw=2 et
