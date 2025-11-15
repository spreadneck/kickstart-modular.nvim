return {
  {
    'NeogitOrg/neogit',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      --      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed.
      --    'ibhagwan/fzf-lua', -- optional
      'nvim-mini/mini.pick', -- optional
      --    'folke/snacks.nvim', -- optional
    },
    cmd = 'Neogit',
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Show Neogit UI' },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
