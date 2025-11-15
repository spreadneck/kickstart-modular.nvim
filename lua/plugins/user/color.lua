return {
  'HoNamDuong/hybrid.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    vim.o.background = 'dark'
    vim.g.hybrid_reduced_contrast = false
    vim.g.hybrid_custom_term_colors = true
    ---@diagnostic disable-next-line: missing-fields
    require('hybrid').setup {
      styles = {
        comments = { italic = false }, -- Disable italics in comments
      },
    }
    vim.cmd.colorscheme 'hybrid'
  end,
}
