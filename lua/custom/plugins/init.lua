return {
  'preservim/vim-markdown',
  'jghauser/follow-md-links.nvim',
  vim.keymap.set('n', '<bs>', ':edit #<cr>', { silent = true }),
}
