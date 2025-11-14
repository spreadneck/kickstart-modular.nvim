return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
      require('mini.tabline').setup()
      require('mini.statusline').setup()
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
      local hipatterns = require 'mini.hipatterns'
      hipatterns.setup {
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }
      local map_multistep = require('mini.keymap').map_multistep

      map_multistep('i', '<Tab>', { 'pmenu_next' })
      map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
      map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
      map_multistep('i', '<BS>', { 'minipairs_bs' })
      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
    keys = {
      { '<leader>e', '<cmd>lua MiniFiles.open()<cr>', desc = 'File Explorer' },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
