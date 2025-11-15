local M = {}

function M.config()
  return {
    {
      'mfussenegger/nvim-lint',
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
        local lint = require 'lint'
        lint.linters_by_ft = {
          markdown = { 'markdownlint' },
          json = { 'jsonlint' },
        }

        local lint_group = vim.api.nvim_create_augroup('nvim-lint', { clear = true })
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
          group = lint_group,
          callback = function()
            lint.try_lint()
          end,
        })
      end,
    },
  }
end

return M
-- vim: ts=2 sts=2 sw=2 et
