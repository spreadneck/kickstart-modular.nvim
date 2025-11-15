local M = {}

function M.config()
  return {
    {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = 'markdown',
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
      opts = {},
    },
  }
end

return M
-- vim: ts=2 sts=2 sw=2 et
