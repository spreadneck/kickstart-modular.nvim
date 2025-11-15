local M = {}

function M.config()
  return {
    {
      'HoNamDuong/hybrid.nvim',
      priority = 1000,
      config = function()
        vim.o.background = 'dark'
        vim.g.hybrid_reduced_contrast = false
        vim.g.hybrid_custom_term_colors = true
        ---@diagnostic disable-next-line: missing-fields
        require('hybrid').setup {
          styles = {
            comments = { italic = false },
          },
        }
        vim.cmd.colorscheme 'hybrid'
      end,
    },
  }
end

return M
-- vim: ts=2 sts=2 sw=2 et
