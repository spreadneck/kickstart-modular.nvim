local pick = require 'core.plugins.mini.pick'

return {
  {
    'nvim-mini/mini.nvim',
    lazy = false,
    priority = 100,
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()

      require('core.plugins.mini.statusline')()
      require('mini.files').setup()
      require('mini.pairs').setup()
      require('mini.bufremove').setup()
      require('mini.indentscope').setup()
      require('mini.notify').setup()
      require('mini.trailspace').setup()
      require('mini.icons').setup()
      require('mini.diff').setup()
      require('mini.git').setup()
      require('mini.comment').setup()

      local map_multistep = require('mini.keymap').map_multistep
      map_multistep('i', '<Tab>', { 'pmenu_next' })
      map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
      map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
      map_multistep('i', '<BS>', { 'minipairs_bs' })

      pick.setup()
      pick.set_keymaps()
      require('core.plugins.mini.extra')()
      require('core.plugins.mini.clue')()
      require('core.plugins.mini.hipatterns')()
    end,
    init = function()
      vim.keymap.set('n', '<leader>e', '<cmd>lua MiniFiles.open()<cr>', { desc = 'File Explorer' })
    end,
  },
}
