local M = {}

function M.config()
  return {
    -- {
    --   'preservim/vim-markdown',
    -- },
    {
      'jghauser/follow-md-links.nvim',
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = 'markdown',
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
      opts = {
        anti_conceal = {
          disabled_modes = { 'n' },
        },
      },
    },
  }
end

return M
